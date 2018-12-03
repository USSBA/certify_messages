require "bundler/setup"
require "certify_messages"
require "byebug"
require "faker"
require "vcr"
require "./spec/support/vcr_helper.rb"

# Don't load all support files, let specs pick and choose
# Dir['./spec/support/**/*.rb'].each { |f| require f }

# configure the CertifyMessages module for testing
CertifyMessages.configure do |config|
  config.api_url = "http://localhost:3001"
  config.excon_timeout = 6
  config.log_level = "unknown"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
