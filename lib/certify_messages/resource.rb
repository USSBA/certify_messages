require 'json'
require 'excon'

module CertifyMessages
  # base resource class
  class Resource
    # excon connection
    def self.connection
      Excon.new(CertifyMessages.endpoint)
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
