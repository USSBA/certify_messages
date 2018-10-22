# coding: utf-8

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'certify_messages/version'

# rubocop:disable BlockLength
Gem::Specification.new do |spec|
  spec.name          = "certify_messages"
  spec.version       = CertifyMessages::VERSION::STRING
  spec.authors       = ["Fearless Solutions, LLC"]
  spec.email         = [""]

  spec.summary       = "Ruby Gem to wrap the Certify Messaging API"
  spec.description   = "Ruby Gem to wrap the Certify Messaging API (GIT_DESCRIBE)"
  spec.homepage      = "https://github.com/USSBA/certify_messages"
  spec.license       = ""

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # NOTE: this may not work since uploading a gem should be done via `gem inabox [gemfile]`
    spec.metadata['allowed_push_host'] = 'http://geminabox.sba-one.net'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.53.0"
  spec.add_development_dependency "rubocop-rspec", "1.23.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "vcr"

  spec.add_dependency "excon"
  spec.add_dependency "excon-rails"
  spec.add_dependency "json"
end
# rubocop:enable BlockLength
