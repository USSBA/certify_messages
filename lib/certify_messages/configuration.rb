module CertifyMessages
  # configuration module
  class Configuration
    attr_accessor :excon_timeout, :api_url, :msg_api_version, :path_prefix, :conversations_path, :messages_path, :logger, :log_level

    # main api endpoint
    def initialize
      @excon_timeout = 20
      @api_url = "http://localhost:3001"
      @msg_api_version = 1
      @path_prefix = "/msg"
      @conversations_path = "conversations"
      @messages_path = "messages"
      @log_level = "debug"
      @logger = nil
    end
  end
end
