module CertifyMessages
  # conversation class that handles getting and posting new conversations
  class Conversation < Resource
    # base conversation finder
    def self.find(params)
      safe_params = conversation_safe_params params
      return error_response("Invalid parameters submitted", 400) if safe_params.empty? && !params.empty?
      response = connection.request(method: :get,
                                    path: conversations_path + "?" +
                                    safe_params)
      response.body = json response
      response
    rescue Excon::Error::Socket => error
      error_response(error.message, 503)
    end

    # create a new conversation and a new message along with it
    def self.create(params)
      safe_params = conversation_safe_params params
      return error_response("Invalid parameters submitted", 400) if safe_params.empty? && !params.empty?
      response = connection.request(method: :post,
                                    path: conversations_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      response.body = json response
      response
    rescue Excon::Error::Socket => error
      error_response(error.message, 503)
    end

    private_class_method

    # helper for the conversations path
    def self.conversations_path
      CertifyMessages.conversations_path
    end

    # helper for white listing parameters
    def self.conversation_safe_params(params)
      permitted_keys = %w[id subject application_id analyst_id contributor_id]
      params = params.select { |key, _| permitted_keys.include? key.to_s }
      URI.encode_www_form(params)
    end
  end
end
