module CertifyMessages
  # configuration module
  class Configuration
    attr_accessor :api_url, :conversations_path, :messages_path

    # main api endpoint
    def initialize
      @api_url = nil
      @conversations_path = "conversations"
      @messages_path = "messages"
    end
  end
end
