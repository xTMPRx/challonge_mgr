class Match < ApplicationRecord
    belongs_to :tournament

    scope :complete?, -> { where(state: "complete") }
    scope :has_team?, ->(id) { where("team1_id = ? OR team2_id = ?", id, id) }
    scope :winner?, ->(id) { complete?.where(winner_id: id) }
    scope :loser?, ->(id) { complete?.has_team?(id).where.not(winner_id: id) }

    def complete?
        return state == "complete"
    end

    def team1_won?
        return complete? && team1_id == winner_id
    end

    def team2_won?
        return complete? && team2_id == winner_id
    end

    def team1_score
        return scores_csv.blank? ? 0 : scores_csv.partition(",")[0].split("-")[0]
    end

    def team2_score
        return scores_csv.blank? ? 0 : scores_csv.partition(",")[0].split("-")[1]
    end
end
