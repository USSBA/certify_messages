require 'vcr'

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :excon
  config.allow_http_connections_when_no_cassette = true
end
