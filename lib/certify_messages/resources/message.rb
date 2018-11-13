module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    # Basic message finder
    # rubocop:disable Metrics/AbcSize
    def self.find(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = message_safe_params params

      # use safe_params to pass in order manually
      order = "?order=#{safe_params[:order]}" unless safe_params[:order].nil?

      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_path(safe_params, order))
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
      permitted_keys_v1 = %w[sender_id recipient_id conversation_id id]
      permitted_keys_v3 = %w[sender_uuid recipient_uuid conversation_uuid message_uuid]
      permitted_keys = %w[body read sent priority_read_receipt order]
      # NOTE: ternary statement will need to be replaced once we have more than two versions to support
      msg_api_version == 3 ? permitted_keys.push(*permitted_keys_v3) : permitted_keys.push(*permitted_keys_v1)
      symbolize_params(params.select { |key, _| permitted_keys.include? key.to_s })
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

    def self.build_find_path(params, order)
      "#{path_prefix}/#{conversations_path}/#{params[:conversation_id]}/#{messages_path}#{order}"
    end

    def self.build_create_path(params)
      "#{path_prefix}/#{conversations_path}/#{params[:conversation_id]}/#{messages_path}"
    end

    def self.build_update_path(params)
      "#{path_prefix}/#{conversations_path}/#{params[:conversation_id]}/#{messages_path}/#{params[:id]}"
    end
  end
end
