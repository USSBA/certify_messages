# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
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
    spec.metadata['allowed_push_host'] = 'http://artifactory.maint.sba-one.net:8081/artifactory/api/gems/gems-local' #"TODO: Set to 'http://mygemserver.com'"
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
  spec.add_development_dependency "rubocop", "~> 0.49.1"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "excon"
  spec.add_dependency "excon-rails"
  spec.add_dependency "json"
  
  spec.add_development_dependency "logger"
end
