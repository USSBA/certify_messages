require 'json'
require 'excon'

module CertifyMessages
  # Controls the API connection
  class ApiConnection
    attr_accessor :conn
    def initialize(url, timeout)
      @conn = Excon.new(url,
                        connect_timeout: timeout,
                        read_timeout: timeout,
                        write_timeout: timeout)
    end

    def request(options)
      add_version_to_header options
      @conn.request(options)
    end

    def add_version_to_header(options)
      version = CertifyMessages.configuration.msg_api_version
      if options[:headers]
        options[:headers].merge!('Accept' => "application/sba.msg-api.v#{version}")
      else
        options.merge!(headers: { 'Accept' => "application/sba.msg-api.v#{version}" })
      end
    end
  end

  # base resource class
  # rubocop:disable Style/ClassVars
  class Resource
    @@connection = nil

    # excon connection
    def self.connection
      @@connection ||= ApiConnection.new api_url, excon_timeout
    end

    def self.clear_connection
      @@connection = nil
    end

    def self.excon_timeout
      CertifyMessages.configuration.excon_timeout
    end

    def self.api_url
      CertifyMessages.configuration.api_url
    end

    def self.path_prefix
      CertifyMessages.configuration.path_prefix
    end

    def self.conversations_path
      CertifyMessages.configuration.conversations_path
    end

    def self.messages_path
      CertifyMessages.configuration.messages_path
    end

    def self.unread_message_counts_path
      CertifyMessages.configuration.unread_message_counts_path
    end

    # empty params
    def self.empty_params(params)
      params.nil? || !params.respond_to?(:empty?) || params.empty?
    end

    def self.logger
      CertifyMessages.configuration.logger ||= (DefaultLogger.new log_level).logger
    end

    def self.log_level
      CertifyMessages.configuration.log_level
    end

    def self.handle_excon_error(error)
      logger.error [error.message, error.backtrace.join("\n")].join("\n")
      CertifyMessages.service_unavailable error.message
    end

    # json parse helper
    def self.json(response)
      JSON.parse(response)
    end

    def self.return_response(body, status)
      {body: body, status: status}
    end
  end
end
