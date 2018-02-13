class GameLockerAPI
  class Match
    attr_accessor :uuid, :shard_id, :blue_team, :red_team, :rosters, :participants, :players
    attr_accessor :created_at, :duration, :gamemode, :end_game_reason, :telemetry_url

    def initialize(data, index = nil)
      if index
        self.uuid = data['data'][index]['id']
        self.shard_id = data['data'][index]['attributes']['shardId']
        self.created_at = data['data'][index]['attributes']['createdAt']
        self.duration = data['data'][index]['attributes']['duration']
        self.gamemode = data['data'][index]['attributes']['gameMode']
        self.end_game_reason = data['data'][index]['attributes']['stats']['endGameReason']
      else
        self.uuid = data['data']['id']
        self.shard_id = data['data']['attributes']['shardId']
        self.created_at = data['data']['attributes']['createdAt']
        self.duration = data['data']['attributes']['duration']
        self.gamemode = data['data']['attributes']['gameMode']
        self.end_game_reason = data['data']['attributes']['stats']['endGameReason']
      end
      self.telemetry_url = nil
      self.rosters = []
      self.red_team = []
      self.blue_team= []
      self.players = []
      self.participants = []

      if index
        data['included'].each do |wanted|
          self.telemetry_url = wanted['attributes']['URL'] if wanted['type'] == "asset" && data['data'][index]['relationships']['assets']['data'].first['id'] == wanted['id']
          thing = nil
          if wanted['id'] == data['data'][index]['relationships']['rosters']['data'][0]['id']
            thing = data['data'][index]['relationships']['rosters']['data'][0]['id']
            self.rosters << compose_roster(data, thing, self)
          elsif wanted['id'] == data['data'][index]['relationships']['rosters']['data'][1]['id']
            thing = data['data'][index]['relationships']['rosters']['data'][1]['id']
            self.rosters << compose_roster(data, thing, self)
          else
            next
          end
        end
      else
        data['included'].each do |wanted|
          self.telemetry_url = wanted['attributes']['URL'] if wanted['type'] == "asset" && data['data']['relationships']['assets']['data'].first['id'] == wanted['id']
          thing = nil
          if wanted['id'] == data['data']['relationships']['rosters']['data'][0]['id']
            thing = data['data']['relationships']['rosters']['data'][0]['id']
            self.rosters << compose_roster(data, thing, self)
          elsif wanted['id'] == data['data']['relationships']['rosters']['data'][1]['id']
            thing = data['data']['relationships']['rosters']['data'][1]['id']
            self.rosters << compose_roster(data, thing, self)
          else
            next
          end
        end
      end

      return self
    end

    def compose_roster(data, roster, temp_match)
      temp_roster = Roster.new
      temp_roster.uuid = roster
      temp_roster.participants = []
      data['included'].each do |local_roster|
        next unless local_roster['type'] == "roster"
        if local_roster['id'] == roster
          temp_roster.aces_earned = local_roster['attributes']['stats']['acesEarned']
          temp_roster.gold        = local_roster['attributes']['stats']['gold']
          temp_roster.hero_kills  = local_roster['attributes']['stats']['heroKills']
          temp_roster.kraken_captures  = local_roster['attributes']['stats']['krakenCaptures']
          temp_roster.side  = local_roster['attributes']['stats']['side']
          temp_roster.turret_kills  = local_roster['attributes']['stats']['turretKills']
          temp_roster.turrets_remaining  = local_roster['attributes']['stats']['turretsRemaining']

          local_roster['relationships']['participants']['data'].each do |pat|
            data['included'].each do |local_participant|
              next unless local_participant['id'] == pat['id']
              temp_participant = Participant.new
              temp_participant.uuid = local_participant['id']
              temp_participant.assists = local_participant['attributes']['stats']['assists']
              temp_participant.crystal_mine_captures = local_participant['attributes']['stats']['crystalMineCaptures']
              temp_participant.deaths = local_participant['attributes']['stats']['deaths']
              temp_participant.farm = local_participant['attributes']['stats']['farm']
              temp_participant.first_afk_time = local_participant['attributes']['stats']['firstAfkTime']
              temp_participant.gold = local_participant['attributes']['stats']['gold']
              temp_participant.gold_mine_captures = local_participant['attributes']['stats']['goldMineCaptures']
              temp_participant.item_grants = local_participant['attributes']['stats']['itemGrants']
              temp_participant.item_sells = local_participant['attributes']['stats']['itemSells']
              temp_participant.item_uses = local_participant['attributes']['stats']['itemUses']
              temp_participant.items = local_participant['attributes']['stats']['items']
              temp_participant.jungle_kills = local_participant['attributes']['stats']['jungleKills']
              temp_participant.karma_level = local_participant['attributes']['stats']['karmaLevel']
              temp_participant.kills = local_participant['attributes']['stats']['kills']
              temp_participant.kraken_captures = local_participant['attributes']['stats']['krakenCaptures']
              temp_participant.level = local_participant['attributes']['stats']['level']
              temp_participant.minion_kills = local_participant['attributes']['stats']['minionKills']
              temp_participant.non_jungle_minion_kills = local_participant['attributes']['stats']['nonJungleMinionKills']
              temp_participant.skill_tier = local_participant['attributes']['stats']['skillTier']
              temp_participant.skin_key = local_participant['attributes']['stats']['skinKey']
              temp_participant.turret_captures = local_participant['attributes']['stats']['turretCaptures']
              temp_participant.went_afk = local_participant['attributes']['stats']['wentAfk']
              temp_participant.winner = local_participant['attributes']['stats']['winner']
              temp_participant.actor = local_participant['attributes']['actor']

              temp_player = nil
              data['included'].each do |local_player|
                next unless local_player['id'] == local_participant['relationships']['player']['data']['id']
                temp_player = Player.new(local_player)
              end
              temp_participant.player = temp_player
              temp_match.players.push(temp_player)

              temp_match.participants.push(temp_participant)
              temp_roster.participants.push(temp_participant)
            end
          end
        end
      end

      if temp_roster.side.include?("red")
        temp_match.red_team.push(temp_roster)
      elsif temp_roster.side.include?("blue")
        temp_match.blue_team.push(temp_roster)
      end
      return temp_roster
    end
  end
end
