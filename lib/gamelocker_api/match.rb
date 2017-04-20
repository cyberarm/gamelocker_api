class GameLockerAPI
  class Match
    attr_accessor :uuid, :shard_id, :blue_team, :red_team, :rosters, :participants, :players
    attr_accessor :created_at, :duration, :gamemode, :end_game_reason, :telemetry_url
  end
end
