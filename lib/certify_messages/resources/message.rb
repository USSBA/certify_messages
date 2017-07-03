module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    # Basic message finder
    # rubocop:disable Metrics/AbcSize
    def self.find(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = message_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyMessages.service_unavailable error.class
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
      CertifyMessages.service_unavailable error.class
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
      CertifyMessages.service_unavailable error.class
    end

    private_class_method

    def self.check_empty_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # Sanitizes the provided paramaters
    def self.message_safe_params(params)
      permitted_keys = %w[body sender_id recipient_id conversation_id read sent id]
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    def self.build_find_path(params)
      "#{path_prefix}/#{conversations_path}/#{params['conversation_id']}/#{messages_path}"
    end

    def self.build_create_path(params)
      "#{path_prefix}/#{conversations_path}/#{params[:conversation_id]}/#{messages_path}"
    end

    def self.build_update_path(params)
      "#{path_prefix}/#{conversations_path}/#{params[:conversation_id]}/#{messages_path}/#{params[:id]}"
    end
  end
end
