class GameLockerAPI
  class AbstractParser
    def self.guess(end_point, data)
      if end_point == "matches"
        match(data)
      elsif end_point.start_with?("matches/")
        match(data, true)

      elsif end_point == "players"
        player(data)
      elsif end_point.start_with?("players/")
        player(data, true)

      else
        raise "(0_-)\nCouldn't guess what parser to use, sorry.\nEndpoint was: #{end_point}"
      end
    end

    # Might only work with MATCHES... []
    def self.match(data, solo = false)
      _matches = []
      temp_match = nil
      if solo
        temp_match = Match.new(data)
      else
        data['data'].each_with_index do |m, i|
          temp_match = Match.new(data, i) # Need to pass index
          _matches.push(temp_match)
        end
      end
      solo ? temp_match : _matches
    end

    def self.player(data, solo = false)
      temp_players = []
      temp_player  = nil
      unless solo
        data['data'].each do |local_player|
          temp_player  = Player.new(local_player)
          temp_players.push(temp_player)
        end
      else
        temp_player  = Player.new(data['data'])
      end

      solo ? temp_player : temp_players
    end

    def self.roster(data)
    end

    # Expects a roster uuid
    def self.participant(roster)
    end
  end
end
