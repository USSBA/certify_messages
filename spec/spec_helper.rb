require "bundler/setup"
require "certify_messages"
require "byebug"
require "faker"

Dir['./spec/support/**/*.rb'].each { |f| require f }

# configure the CertifyMessages module for testing
CertifyMessages.configure do |config|
  config.api_url = "http://foo.bar/"
  config.excon_timeout = 6
  config.log_level = "unknown"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    Excon.defaults[:mock] = true
    Excon.stub({}, body: { message: 'Fallback stub response' }.to_json, status: 598)
  end
  config.after(:each) do
    Excon.stubs.clear
  end
end
