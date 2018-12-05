# frozen_string_literal: true

class TournamentViewerController < ApplicationController
    before_action :set_tournament_from_slug

    SYMBOLS_GB = %i(gold blue).freeze

    def view
        @user = @tournament.user
        @current_match = @tournament.current_match_obj
        @upcoming_matches = @tournament.matches.upcoming
        @completed_matches = @tournament.matches.completed
        @teams_in_seed_order = @tournament.teams.order(seed: :asc)

        if @tournament.complete?
            @teams_in_final_rank_order = @tournament.teams.where.not(final_rank: nil).
                                         order(final_rank: :asc, seed: :asc)
        end

        render "tournaments/show", layout: "tournament_view"
    end

    def gold
        render plain: current_match_team_name(:gold)
    end

    def blue
        render plain: current_match_team_name(:blue)
    end

    def gold_score
        render plain: current_match_team_score(:gold)
    end

    def blue_score
        render plain: current_match_team_score(:blue)
    end

    protected

    def current_match_team_name(side)
        ApplicationHelper.validate_param(side, SYMBOLS_GB)

        # If a match is in progress, query the team name from that match.
        # Otherwise, use the team name that we stored when the match finished.
        name = if @tournament.current_match_obj.present?
                   @tournament.current_match_obj.team_name(side)
               else
                   (side == :gold) ? @tournament.view_gold_name :
                                     @tournament.view_blue_name
               end

        # Remove a parenthesized part from the end of the team name.  This lets
        # the Challonge bracket have names like "Bert's Bees (PHX)", but the
        # name on the stream will be just "Bert's Bees".  That saves space on the
        # stream, which is espcially necessary with multi-scene teams that have
        # multiple cities in the name.
        return name&.sub(/\(.*?\)$/, "")&.strip || ""
    end

    def current_match_team_score(side)
        ApplicationHelper.validate_param(side, SYMBOLS_GB)

        # If a match is in progress, query the score from that match.
        # Otherwise, use the score that we stored when the match finished.
        score = if @tournament.current_match_obj.present?
                    @tournament.current_match_obj.team_score(side)
                else
                    (side == :gold) ? @tournament.view_gold_score :
                                      @tournament.view_blue_score
                end

        return score || 0
    end
end
