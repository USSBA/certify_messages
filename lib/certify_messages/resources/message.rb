module CertifyMessages
  # message class that handles geting and posting messages
  class Message < Resource
    def self.find(params)
      safe_params = message_params params
      return "Invalid parameters submitted" if safe_params.empty? && !params.empty?
      response = connection.request(method: :get,
                                    path: conversations_path + "/#{safe_params['conversation_id']}/" + messages_path + "?" +
                                    safe_params)
      json response
    end

    def self.conversations_path
      CertifyMessages.conversations_path
    end

    def self.messages_path
      CertifyMessages.messages_path
    end

    def self.message_params(params)
      permitted_keys = %w[body sender_id recipient_id conversation_id read sent]
      params = params.select { |key, _| permitted_keys.include? key.to_s }
      URI.encode_www_form(params)
    end
  end
end
