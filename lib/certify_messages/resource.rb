require 'json'
require 'excon'

module CertifyMessages
  # base resource class
  class Resource
    # excon connection
    def self.connection
      Excon.new(api_url)
    end

    def self.api_url
      CertifyMessages.configuration.api_url
    end

    def self.conversations_path
      CertifyMessages.configuration.conversations_path
    end

    def self.messages_path
      CertifyMessages.configuration.messages_path
    end

    # json parse helper
    def self.json(response)
      JSON.parse(response.body)
    end

    def self.error_response(message, status)
      { body: message, status: status }
    end
  end
end
