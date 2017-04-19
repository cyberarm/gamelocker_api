class GameLockerAPI
  class Player
    attr_accessor :uuid, :name, :shard_id, :created_at
    attr_accessor :level, :lifetime_gold, :loss_streak, :win_streak, :played, :played_ranked, :wins, :xp
  end
end
