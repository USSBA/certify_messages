module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    # Basic message finder
    def self.find(params)
      return error_response("Invalid parameters submitted", 400) if valid_params(params)
      safe_params = message_params params
      response = connection.request(method: :get,
                                    path: conversations_path + "/#{safe_params['conversation_id']}/" + messages_path + "?" +
                                    safe_params)
      json response
    end

    # Message creator
    def self.create(params)
      safe_params = message_params params
      return error_response("Invalid parameters submitted", 422) if safe_params.empty? && !params.empty?
      connection.request(method: :post,
                         path: "/conversations/#{params[:conversation_id]}/messages",
                         body: safe_params.to_json,
                         headers:  { "Content-Type" => "application/json" })
    end

    def self.conversations_path
      CertifyMessages.conversations_path
    end

    def self.messages_path
      CertifyMessages.messages_path
    end

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
  end
end
