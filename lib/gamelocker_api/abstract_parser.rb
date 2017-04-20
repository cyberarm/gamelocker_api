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
      unless solo
        data['data'].each do |match|
          temp_match = Match.new
          _matches.push(temp_match)
          temp_match.uuid = match['id']
          temp_match.shard_id = match['attributes']['shardId']
          temp_match.created_at = match['attributes']['createdAt']
          temp_match.duration = match['attributes']['duration']
          temp_match.gamemode = match['attributes']['gameMode']
          temp_match.end_game_reason = match['attributes']['stats']['endGameReason']
          temp_match.telemetry_url = nil
          temp_match.rosters = []
          temp_match.red_team = []
          temp_match.blue_team= []
          temp_match.players = []
          temp_match.participants = []
          data['included'].each do |wanted|
            temp_match.telemetry_url = wanted['attributes']['URL'] if wanted['type'] == "asset" && match['relationships']['assets']['data'].first['id'] == wanted['id']
            thing = nil
            if wanted['id'] == match['relationships']['rosters']['data'][0]['id']
              thing = match['relationships']['rosters']['data'][0]['id']
              temp_match.rosters << compose_roster(data, thing, temp_match)
            elsif wanted['id'] == match['relationships']['rosters']['data'][1]['id']
              thing = match['relationships']['rosters']['data'][1]['id']
              temp_match.rosters << compose_roster(data, thing, temp_match)
            else
              next
            end
          end
        end
      else
        temp_match = Match.new
        match = data['data']
        temp_match.uuid = match['id']
        temp_match.shard_id = match['attributes']['shardId']
        temp_match.created_at = match['attributes']['createdAt']
        temp_match.duration = match['attributes']['duration']
        temp_match.gamemode = match['attributes']['gameMode']
        temp_match.end_game_reason = match['attributes']['stats']['endGameReason']
        temp_match.rosters = []
        temp_match.red_team = []
        temp_match.blue_team= []
        temp_match.players = []
        temp_match.participants = []
        data['included'].each do |wanted|
          temp_match.telemetry_url = wanted['attributes']['URL'] if wanted['type'] == "asset" && match['relationships']['assets']['data'].first['id'] == wanted['id']
          thing = nil
          if wanted['id'] == match['relationships']['rosters']['data'][0]['id']
            thing = match['relationships']['rosters']['data'][0]['id']
            temp_match.rosters << compose_roster(data, thing, temp_match)
          elsif wanted['id'] == match['relationships']['rosters']['data'][1]['id']
            thing = match['relationships']['rosters']['data'][1]['id']
            temp_match.rosters << compose_roster(data, thing, temp_match)
          else
            next
          end
        end
      end
      solo ? temp_match : _matches
    end

    def self.player(data, solo = false)
      temp_players = []
      temp_player  = nil
      unless solo
        data['data'].each do |local_player|
          temp_player  = Player.new

          temp_player.uuid = local_player['id']
          temp_player.level = local_player['attributes']['stats']['level']
          temp_player.lifetime_gold = local_player['attributes']['stats']['lifetimeGold']
          temp_player.loss_streak = local_player['attributes']['stats']['lossStreak']
          temp_player.played = local_player['attributes']['stats']['played']
          temp_player.played_ranked = local_player['attributes']['stats']['played_ranked']
          temp_player.win_streak = local_player['attributes']['stats']['winStreak']
          temp_player.wins = local_player['attributes']['stats']['wins']
          temp_player.xp = local_player['attributes']['stats']['xp']
          temp_player.name = local_player['attributes']['name']
          temp_player.created_at = local_player['attributes']['createdAt']

          temp_players.push(temp_player)
        end
      else
        temp_player  = Player.new

        local_player = data['data']
        temp_player.uuid = local_player['id']
        temp_player.level = local_player['attributes']['stats']['level']
        temp_player.lifetime_gold = local_player['attributes']['stats']['lifetimeGold']
        temp_player.loss_streak = local_player['attributes']['stats']['lossStreak']
        temp_player.played = local_player['attributes']['stats']['played']
        temp_player.played_ranked = local_player['attributes']['stats']['played_ranked']
        temp_player.win_streak = local_player['attributes']['stats']['winStreak']
        temp_player.wins = local_player['attributes']['stats']['wins']
        temp_player.xp = local_player['attributes']['stats']['xp']
        temp_player.name = local_player['attributes']['name']
        temp_player.created_at = local_player['attributes']['createdAt']
      end

      solo ? temp_player : temp_players
    end

    def self.roster(data)
    end

    # Expects a roster uuid
    def self.participant(roster)
    end

    private
    def self.compose_roster(data, roster, temp_match)
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

              temp_player = Player.new
              data['included'].each do |local_player|
                next unless local_player['id'] == local_participant['relationships']['player']['data']['id']
                temp_player.uuid = local_player['id']
                temp_player.level = local_player['attributes']['stats']['level']
                temp_player.lifetime_gold = local_player['attributes']['stats']['lifetimeGold']
                temp_player.loss_streak = local_player['attributes']['stats']['lossStreak']
                temp_player.played = local_player['attributes']['stats']['played']
                temp_player.played_ranked = local_player['attributes']['stats']['played_ranked']
                temp_player.win_streak = local_player['attributes']['stats']['winStreak']
                temp_player.wins = local_player['attributes']['stats']['wins']
                temp_player.xp = local_player['attributes']['stats']['xp']
                temp_player.name = local_player['attributes']['name']
                temp_player.created_at = local_player['attributes']['createdAt']
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
