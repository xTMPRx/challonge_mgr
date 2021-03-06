# frozen_string_literal: true

module ChallongeHelper
    # On success, returns an array of `tournament` objects that represent the
    # tournaments that are owned by the user.  If the user is in an organization,
    # the array also contains the tournaments that are owned by that organization.
    # On failure, returns an `error` object that describes the error.
    def get_tournament_list(user)
        url = get_api_url
        tournaments = send_get_request(url, user)

        # If an error occured, `send_get_request` will return a hash instead of
        # an array.
        return tournaments unless tournaments.is_a?(Array)

        if user.subdomain.present?
            org_tournaments = send_get_request(url, user, subdomain: user.subdomain)

            tournaments.concat(org_tournaments) if org_tournaments.is_a?(Array)
        end

        return tournaments
    end

    # On success, returns a `tournament` object that contains the properties of
    # the given tournament. The caller can also request the teams and matches in
    # the tournament.
    # On failure, returns an `error` object that describes the error.
    def get_tournament_info(tournament, get_teams:, get_matches:)
        url = get_api_url("#{tournament.challonge_id}.json")
        params = { include_participants: get_teams ? 1 : 0,
                   include_matches: get_matches ? 1 : 0 }

        return send_get_request(url, tournament.user, params)
    end

    # Sets the scores and optionally the winning team for a match.
    # On success, returns a `match` object that contains the updated properties
    # of the match.
    # On failure, returns an `error` object that describes the error.
    def update_match(match, new_scores_csv, winner_id)
        url = get_api_url("#{match.tournament.challonge_id}/matches/" \
                            "#{match.challonge_id}.json")

        params = { "match[scores_csv]" => new_scores_csv }
        params["match[winner_id]"] = winner_id if winner_id.present?

        return send_put_request(url, match.tournament.user, params)
    end

    # Finalizes a tournament.  All matches in the tournament must be complete
    # for this call to succeed.
    # On success, returns a `tournament` object that contains the properties of
    # the tournament.
    # On failure, returns an `error` object that describes the error.
    def finalize_tournament(tournament)
        url = get_api_url("#{tournament.challonge_id}/finalize.json")

        return send_post_request(url, tournament.user)
    end

    # Creates a quick start demo tournament on Challonge.
    # On success, returns a `tournament` object that contains the properties of
    # the new tournament.
    # On failure, returns an `error` object that describes the error.
    def make_demo_tournament(user, name, desc)
        # Create the tournament on Challonge.
        resp = send_post_request(
                 get_api_url, user,
                 "tournament[name]" => name,
                 "tournament[tournament_type]" => "double elimination",
                 "tournament[description]" => desc,
                 "tournament[hide_forum]" => "true",
                 "tournament[show_rounds]" => "true",
                 "tournament[private]" => "true",
                 "tournament[url]" => SecureRandom.hex(8))

        # Add teams to the tournament.
        if api_succeeded?(resp)
            alphanumeric_id = resp["tournament"]["url"]
            url = get_api_url("#{alphanumeric_id}/participants/bulk_add.json")

            team_names = (1..6).each_with_object([]) do |n, obj|
                obj << I18n.t("quick_start.team#{n}")
            end

            resp = send_post_request(url, user,
                                     "participants[][name]" => team_names)
        end

        # Start the tournament.
        if api_succeeded?(resp)
            url = get_api_url("#{alphanumeric_id}/start.json")
            resp = send_post_request(url, user)
        end

        return resp
    end

    private

    # Returns a string that holds the URL to the Challonge API endpoint, with
    # `str` appended to it.  Since all API URLs start with "tournaments", the
    # caller should not include that in `str`.  Omitting `str` will return the
    # URL for the "tournaments.json" endpoint.
    def get_api_url(str = nil)
        base_url = "https://api.challonge.com/v1/tournaments"

        return str ? "#{base_url}/#{str}" : "#{base_url}.json"
    end

    # Takes a response object from a Challonge API call, and returns true if
    # the response indicates that the call succeeded.
    def api_succeeded?(response)
        return !response.try(:key?, :error)
    end

    # Sends a GET request to `url`, treats the returned data as JSON, and parses
    # it into an object.  On success, the return value is that object.  On
    # failure, the return value is a hash that describes the error.
    def send_get_request(url, user, params = {})
        params = params.reverse_merge(api_key: user.api_key)
        response = RestClient.get(url, params: params)
        return JSON.parse(response.body)
    rescue => e
        return handle_request_error(e, __method__)
    end

    # Sends a PUT request to `url`, passing `params` with the request.  It treats
    # the returned data as JSON, and parses it into an object.  On success,
    # the return value is that object.  On failure, the return value is a hash
    # that describes the error.
    def send_put_request(url, user, params)
        params = params.reverse_merge(api_key: user.api_key)
        response = RestClient.put(url, params)
        return JSON.parse(response.body)
    rescue => e
        return handle_request_error(e, __method__)
    end

    # Sends a POST request to `url`.  It treats the returned data as JSON, and
    # parses it into an object.  On success, the return value is that object.
    # On failure, the return value is a hash that describes the error.
    def send_post_request(url, user, params = {})
        params = params.reverse_merge(api_key: user.api_key)
        post_data = URI.encode_www_form(params)
        response = RestClient.post(url, post_data)
        return JSON.parse(response.body)
    rescue => e
        return handle_request_error(e, __method__)
    end

    # Returns a hash in this form:
    # { error: { object: <the exception>,
    #            message: <error messages, separated by semicolons>,
    #            http_code: <the HTTP response code, if it's known>
    # } }
    def handle_request_error(exception, method_name)
        Rails.logger.error "Exception (#{exception.class.name}) in " \
                             "#{method_name}: #{exception.message}"
        message = nil

        # When an API call fails, Challonge returns a list of errors in the body.
        # Look for that list in the response.
        if exception.is_a?(RestClient::ExceptionWithResponse)
            Rails.logger.error "Response body: #{exception.response}"

            # Swallow exceptions if the response isn't JSON.  This happens when
            # the API key is wrong, because the server returns just the string
            # "HTTP Basic: Access denied."
            # This isn't a problem, because `ApplicationController#api_failed?`
            # special-cases 401 responses and shows a custom error message.
            begin
                resp = JSON.parse(exception.response.to_s)
            rescue JSON::ParserError
                resp = nil
            end

            if resp.try(:key?, "errors")
                message = [ exception.message, resp["errors"] ].join("; ")
            end
        end

        message ||= exception.message

        err = { object: exception, message: message }
        err[:http_code] = exception.http_code if exception.respond_to?(:http_code)

        return { error: err }
    end
end
