module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    # Basic message finder
    # rubocop:disable Metrics/AbcSize
    def self.where(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = message_safe_params params

      # use safe_params to pass in order manually
      order = "?order=#{safe_params[:order]}" unless safe_params[:order].nil?

      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_where_path(safe_params, order))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    def self.find(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = message_safe_params params

      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    # Message creator
    def self.create(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = message_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    #Message editor
    def self.update(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = message_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :put,
                                    path: build_update_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(check_empty_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end
    # rubocop:enable Metrics/AbcSize

    private_class_method

    def self.check_empty_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # Sanitizes the provided paramaters
    def self.message_safe_params(params)
      permitted_keys = %w[body read sent priority_read_receipt order]
      permitted_keys.push(*version_specific_keys)
      symbolize_params(params.select { |key, _| permitted_keys.include? key.to_s })
    end

    def self.version_specific_keys
      case msg_api_version
      when 1
        %w[sender_id recipient_id conversation_id id]
      when 2
        %w[sender_uuid recipient_uuid conversation_uuid uuid]
      when 3
        %w[sender_uuid recipient_uuid conversation_uuid uuid]
      end
    end

    def self.symbolize_params(params)
      # rebuild params as symbols, dropping ones as strings
      symbolized_params = {}
      params.each do |key, value|
        if key.is_a? String
          symbolized_params[key.to_sym] = value
        else
          symbolized_params[key] = value
        end
      end
      symbolized_params
    end

    def self.build_where_path(params, order)
      "#{path_prefix}/#{conversations_path}/#{conversation_param_value(params)}/#{messages_path}#{order}"
    end

    def self.build_find_path(params)
      "#{path_prefix}/#{conversations_path}/#{conversation_param_value(params)}/#{messages_path}/#{params[:uuid]}"
    end

    def self.build_create_path(params)
      "#{path_prefix}/#{conversations_path}/#{conversation_param_value(params)}/#{messages_path}"
    end

    def self.build_update_path(params)
      "#{path_prefix}/#{conversations_path}/#{conversation_param_value(params)}/#{messages_path}/#{message_param_value(params)}"
    end

    # Returns ID or UUID value based on version
    def self.conversation_param_value(params)
      case msg_api_version
      when 1
        params[:conversation_id]
      when 2
        params[:conversation_uuid]
      when 3
        params[:conversation_uuid]
      end
    end
  end
end
