# frozen_string_literal: true

class MatchesController < ApplicationController
    before_action :set_match
    before_action :require_login
    before_action :correct_user?

    def start
        # We manually set `underway_at` because the Challonge API doesn't have
        # a way to mark a match as being underway.  If they fix that, then we
        # can remove this line.
        @match.update_attributes(underway_at: Time.now)

        # Tell the tournament that a new match is starting.
        @tournament.set_current_match(@match)

        redirect_to user_tournament_path(@user, @tournament)
    end

    def update
        left_score = params[:left_score]
        right_score = params[:right_score]
        winner_id = params[:winner_id]

        # If `winner_id` is present, then the caller is setting the winner, not
        # changing the score.  Challonge requires us to send the `scores_csv`
        # param, even if we're just setting the winner, so use the match's
        # current scores.
        if winner_id.present?
            # We consider it an error if the caller passed scores and a `winner_id`.
            if left_score.present? || right_score.present?
                head :bad_request
                return
            end

            new_scores_csv = @match.scores_csv
        else
            # Check that the caller passed scores for both sides.
            if left_score.blank? || right_score.blank?
                head :bad_request
                return
            end

            new_scores_csv = @match.make_scores_csv(left_score, right_score)
        end

        # Send the new scores or the winner to Challonge.
        match_hash = ApplicationHelper.update_match(@match, new_scores_csv, winner_id)

        return if api_failed?(match_hash) do |msg|
            redirect_to user_tournament_path(@user, @tournament), notice: msg
        end

        # Challonge responds with the updated JSON for the match.  Read it and
        # update our `Match` object.
        match_obj = OpenStruct.new(match_hash["match"])

        @match.update!(match_obj)

        # If `winner_id` is present, then the current match is over.
        @tournament.set_match_complete(@match) if winner_id.present?

        # If we are finishing a match, then we need to refresh the tournament,
        # because the result of this match may have changed the teams that are
        # in future matches.  If we're just updating the score of the current
        # match, there's no need to refresh the tournament.
        if winner_id.present?
            redirect_to refresh_user_tournament_path(@user, @tournament)
        else
            redirect_to user_tournament_path(@user, @tournament)
        end
    end

    def switch
        @match.switch_team_sides!
        redirect_to user_tournament_path(@user, @tournament)
    end

    protected
    def set_match
        @match = Match.find(params[:id])
        @tournament = @match.tournament
        @user = @tournament.user
    rescue ActiveRecord::RecordNotFound
        render_not_found_error(:match)
    end
end
