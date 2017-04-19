require "rest-client"
require "oj"
require_relative "gamelocker_api/abstract_parser"
require_relative "gamelocker_api/match"
require_relative "gamelocker_api/player"
require_relative "gamelocker_api/roster"
require_relative "gamelocker_api/participant"

class GameLockerAPI
  VirtualResponse = Struct.new(:code, :body)
  attr_reader :base_url, :region, :headers
  def initialize(api_key, region = "na")
    @api_key = api_key
    @region  = region
    @base_url= "https://api.dc01.gamelockerapp.com/shards/"
    @headers = {}
  end

  # Probably does not work
  def player(uuid)
    request("players/#{uuid}", {})
  end

  def players(players_list = [])
    raise "Max of only 6 players" if players_list.count > 6
    string = players_list.join(", ")
    hash   = {"filter[playerNames]": string}
    request("players", hash)
  end

  def match(match_uuid = nil)
    match_uuid ? request("matches/#{match_uuid}") : request("matches")
  end

  def matches(match_params = {})
    request("matches", match_params)
  end

  private
  def request(end_point, params = nil)
    api_headers = {
      "X-TITLE-ID": "semc-vainglory",
      "Authorization": @api_key,
      "Accept": "application/vnd.api+json",
    }

    response = nil
    begin
      if params
        response = RestClient.get(@base_url+@region+"/"+end_point+"?"+URI.encode_www_form(params), api_headers)
      else
        response = RestClient.get(@base_url+@region+"/"+end_point, api_headers)
      end
      @headers = response.headers
      open(Dir.pwd+"/response.dat", "w") do |file|
        file.write(Oj.load(response.body))
      end
      parser(response, end_point)
    rescue RestClient::ExceptionWithResponse => e
      response = VirtualResponse.new(e.response, e.response)
      @headers = e.response.headers
      parser(response, end_point, false)
    end
  end

  def parser(response, end_point, healthy = true)
    return {response: response, data: GameLockerAPI::AbstractParser.guess(end_point, Oj.load(response.body))} if healthy
    return {response: response, data: "{}"} unless healthy
  end
end
