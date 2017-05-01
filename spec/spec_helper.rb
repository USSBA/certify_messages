require "bundler/setup"
require "certify_messages"
require "byebug"

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
end
