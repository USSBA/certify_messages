require 'json'
require 'excon'

module CertifyMessages
  # Controls the API connection
  class ApiConnection
    attr_accessor :conn
    def initialize(url, timeout, api_key = nil)
      params = {
        connect_timeout: timeout,
        read_timeout: timeout,
        write_timeout: timeout
      }
      params[:headers] = { 'x-api-key' => api_key } unless api_key.nil?
      @conn = Excon.new(url, params)
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
      @@connection ||= ApiConnection.new api_url, excon_timeout, api_key
    end

    def self.clear_connection
      @@connection = nil
    end

    def self.excon_timeout
      CertifyMessages.configuration.excon_timeout
    end

    def self.api_key
      CertifyMessages.configuration.api_key
    end

    def self.api_url
      CertifyMessages.configuration.api_url
    end

    def self.msg_api_version
      CertifyMessages.configuration.msg_api_version
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

    # Returns ID or UUID value based on version
    def self.conversation_param_value(params)
      # NOTE: ternary statement will need to be replaced once we have more than two versions to support
      msg_api_version == 3 ? params[:conversation_uuid] : params[:conversation_id]
    end

    # Returns T/F if ID or UUID value was in set of params
    def self.conversation_param_included(params)
      status =
        if CertifyMessages.configuration.msg_api_version == 3
          params.keys.include? :conversation_uuid
        else
          params.keys.include? :conversation_id
        end
      status
    end
  end
  # rubocop:enable Style/ClassVars
end
