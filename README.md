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

TODO: Write usage instructions here
```ruby
  # Api Key and Region
  api = GameLockerAPI.new("API_KEY", "na")
  response = api.players("Cyberarm")
  p response # => GameLockerAPI::Player
```

## Development
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cyberarm/gamelocker_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
