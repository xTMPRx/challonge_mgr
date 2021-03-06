require "test_helper"

class TournamentViewerControllerTest < ActionDispatch::IntegrationTest
    setup do
        @tournament = tournaments(:tournament_1)
        @slug = @tournament.challonge_alphanumeric_id
        @bad_slug = @slug.reverse
    end

    def current_match_properties_test(url, match)
        # The URL should return a default value when no match has been started yet.
        get url
        assert_response :success
        assert_equal yield(:before), response.body

        # Log in so we can start a match.
        log_in_as @tournament.user

        # Start the next match.
        post start_user_tournament_match_path(@tournament.user, @tournament, match)
        assert_response :redirect

        # Check that we're redirected to the right URL.
        assert_redirected_to user_tournament_path(@tournament.user, @tournament)

        follow_redirect!
        assert_response :success

        # The URL should return a string now.
        get url
        assert_equal yield(:after), response.body
    end

    def team_names_in_match_test(team_name_url, match, side)
        current_match_properties_test(team_name_url, match) do |step|
            (step == :before) ? "" : match.team_name(side, use_alt: true)
        end
    end

    def team_scores_in_match_test(team_score_url, match, side)
        current_match_properties_test(team_score_url, match) do |step|
            (step == :before) ? "0" : match.team_score(side).to_s
        end
    end

    test "View a tournament" do
        [ @slug, @slug.upcase ].each do |id|
            get view_tournament_path(id)
            assert_response :success

            assert assigns(:teams_in_seed_order)
            assert_not assigns(:teams_in_final_rank_order)
            assert_template "show", layout: "tournament_view"
        end
    end

    test "View a completed tournament" do
        @tournament = tournaments(:tournament_3)
        @slug = @tournament.challonge_alphanumeric_id

        get view_tournament_path(@slug)
        assert_response :success

        assert assigns(:teams_in_seed_order)
        assert assigns(:teams_in_final_rank_order)
        assert_template "show", layout: "tournament_view"
    end

    test "View a tournament's gold team name" do
        team_names_in_match_test(
            view_tournament_gold_path(@slug),
            @tournament.matches.upcoming.first, :gold)
    end

    test "View a tournament's blue team name" do
        team_names_in_match_test(
            view_tournament_blue_path(@slug),
            @tournament.matches.upcoming.first, :blue)
    end

    test "View a tournament's gold team score" do
        team_scores_in_match_test(
            view_tournament_gold_score_path(@slug),
            @tournament.matches.upcoming.first, :gold)
    end

    test "View a tournament's blue team score" do
        team_scores_in_match_test(
            view_tournament_blue_score_path(@slug),
            @tournament.matches.upcoming.first, :blue)
    end

    test "View a tournament's on-deck gold team name" do
        get view_tournament_on_deck_gold_path(@slug)
        assert_equal @tournament.matches.upcoming.first.team_name(:gold, use_alt: true),
                     response.body
    end

    test "View a tournament's on-deck blue team name" do
        get view_tournament_on_deck_blue_path(@slug)
        assert_equal @tournament.matches.upcoming.first.team_name(:blue, use_alt: true),
                     response.body
    end

    test "Try to view a non-existant tournament" do
        get view_tournament_path(@bad_slug)
        assert_response :not_found
    end

    test "Try to view a non-existant tournament's gold team name" do
        get view_tournament_gold_path(@bad_slug)
        assert_response :not_found
    end

    test "Try to view a non-existant tournament's blue team name" do
        get view_tournament_blue_path(@bad_slug)
        assert_response :not_found
    end

    test "Try to view a non-existant tournament's gold team score" do
        get view_tournament_gold_score_path(@bad_slug)
        assert_response :not_found
    end

    test "Try to view a non-existant tournament's blue team score" do
        get view_tournament_blue_score_path(@bad_slug)
        assert_response :not_found
    end

    test "Try to view a non-existant tournament's on-deck gold team name" do
        get view_tournament_on_deck_gold_path(@bad_slug)
        assert_response :not_found
    end

    test "Try to view a non-existant tournament's on-deck blue team name" do
        get view_tournament_on_deck_blue_path(@bad_slug)
        assert_response :not_found
    end
end
