module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    # Basic message finder
    # rubocop:disable Metrics/AbcSize
    def self.find(params)
      return CertifyMessages.BadRequest if empty_params(params)
      safe_params = message_safe_params params
      return CertifyMessages.Unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    # Message creator
    def self.create(params)
      return CertifyMessages.BadRequest if empty_params(params)
      safe_params = message_safe_params params
      return CertifyMessages.Unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, status: 503)
    end

    #Message editor
    def self.update(params)
      safe_params = message_params params
      return return_response("Invalid parameters submitted", 422) if safe_params.empty? && !params.empty?
      response = connection.request(method: :put,
                                    path: build_update_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      body = response.data[:body].empty? ? { message: 'No Content' } : json(response.data[:body])
      return_response(body, response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    private_class_method

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
