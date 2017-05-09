module CertifyMessages
  # configuration module
  class Configuration
    attr_accessor :api_url, :hubzone_api_version, :path_prefix, :conversations_path, :messages_path

    # main api endpoint
    def initialize
      @api_url = nil
      @hubzone_api_version = 1
      @path_prefix = "/msg"
      @conversations_path = "conversations"
      @messages_path = "messages"
    end
  end
end
