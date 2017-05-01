module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    # Basic message finder
    def self.find(params)
      return return_response("Invalid parameters submitted", 400) if valid_params(params)
      safe_params = message_params params
      response = connection.request(method: :get,
                                    path: build_find_url(safe_params))
      # json response
      return_response( json(response.data[:body]), response.data[:status] )
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    # Message creator
    def self.create(params)
      safe_params = message_params params
      return return_response("Invalid parameters submitted", 422) if safe_params.empty? && !params.empty?
      response = connection.request(method: :post,
                         path: "/conversations/#{params[:conversation_id]}/messages",
                         body: safe_params.to_json,
                         headers:  { "Content-Type" => "application/json" })
      return_response( json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    private_class_method

    # Sanitizes the provided paramaters
    def self.message_params(params)
      permitted_keys = %w[body sender_id recipient_id conversation_id read sent]
      params = params.select { |key, _| permitted_keys.include? key.to_s }
      URI.encode_www_form(params)
    end

    # checks to confirm if the parameters are valid
    def self.valid_params(params)
      message_params(params).empty? && !params.empty?
    end

    def self.build_find_url(params)
      conversations_path + "/#{params['conversation_id']}/" + messages_path + "?" + params
    end
  end
end
