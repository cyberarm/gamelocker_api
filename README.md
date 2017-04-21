# GameLockerAPI

API client for the VainGlory Developer API (which is currently in alpha)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "gamelocker_api"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamelocker_api

## Usage
Get player(s) by In-game name
```ruby
  # Api Key and Region
  api = GameLockerAPI.new("API_KEY", "na")
  response = api.players("Cyberarm") # method :players always returns an Array
  p response.first # => GameLockerAPI::Player
```
Get player by UUID
```ruby
  response = api.player("6168b9ca-e7c8-11e6-812b-06388a2f2ea7")
  p response # => GameLockerAPI::Player
```
Get matches
```ruby
  response = api.matches
  p response # => [GameLockerAPI::Match, GameLockerAPI::Match]
```
Get matches with players that have In-game names
```ruby
  response = api.matches({"filter[playerNames]" => "Cyberarm"}) # Note: Will only return the last 3 hours of matches by default, see https://developer.vainglorygame.com/docs#get-a-collection-of-matches
  p response # => [GameLockerAPI::Match, GameLockerAPI::Match]
```
Get a match
```ruby
  match = api.match("0bf53e9a-268f-11e7-9456-063bc004098b")
  p match # => GameLockerAPI::Match
```
Get telemetry
```ruby
  response = api.telemetry(match.telemetry_url)
  p response # => [GameLockerAPI::Telemetry::Event, GameLockerAPI::Telemetry::Event]
```
Check if you're being rate limited
```ruby
  api.headers[:x_ratelimit_remaining] # => 9
```
## Supports
  * Telemetry
  * Player(s)
  * Match(s)

## Development
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cyberarm/gamelocker_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
