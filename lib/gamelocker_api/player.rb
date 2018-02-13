class GameLockerAPI
  class Player
    attr_accessor :uuid, :name, :shard_id, :created_at
    attr_accessor :games_played, :guild_tag, :karma_level, :level, :rank_points, :skill_tier, :wins, :xp
    attr_accessor :total_games_played, :loses

    def initialize(data)
      self.uuid         = data['id']
      self.name         = data['attributes']['name']
      self.created_at   = data['attributes']['createdAt']

      self.games_played = data['attributes']['stats']['gamesPlayed']
      self.guild_tag    = data['attributes']['stats']['guildTag']
      self.karma_level  = data['attributes']['stats']['karmaLevel']
      self.level        = data['attributes']['stats']['level']
      self.rank_points  = data['attributes']['stats']['rank_points']
      self.skill_tier   = data['attributes']['stats']['skillTier']
      self.wins         = data['attributes']['stats']['wins']
      self.xp           = data['attributes']['stats']['xp']

      calculate_total_games_played
      calculate_loses
      return self
    end

    def calculate_total_games_played
      games = 0
      self.games_played.each do |mode, n|
        games+=n
      end

      self.total_games_played = games
    end

    def calculate_loses
      games = 0
      self.games_played.each do |mode, n|
        games+=n
      end

      self.loses = games-wins
    end
  end
end
