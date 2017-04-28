module CertifyMessages
  # conversation class that handles getting and posting new conversations
  class Conversation < Resource
    # base conversation finder
    def self.find(params)
      safe_params = conversation_params params
      return "Invalid parameters submitted" if safe_params.empty?
      response = connection.request(method: :get,
                                    path: conversations_path + "?" +
                                    safe_params)
      json response
    end

    def self.conversations_path
      CertifyMessages.conversations_path
    end

    def self.conversation_params(params)
      permitted_keys = %w[id subject application_id analyst_id contributor_id]
      params = params.select { |key, _| permitted_keys.include? key.to_s }
      URI.encode_www_form(params)
    end
  end
end
