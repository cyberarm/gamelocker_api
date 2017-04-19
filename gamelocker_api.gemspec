# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamelocker_api/version'

Gem::Specification.new do |spec|
  spec.name          = "gamelocker_api"
  spec.version       = GameLockerAPI::VERSION
  spec.authors       = ["Cyberarm"]
  spec.email         = ["matthewlikesrobots@gmail.com"]

  spec.summary       = %q{API client for the VainGlory Developer API}
  spec.description   = %q{API client for the VainGlory Developer API}
  spec.homepage      = "https://github.com/cyberarm/gamelocker_api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0.1"
  spec.add_dependency "oj", "~> 2.18.5"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
