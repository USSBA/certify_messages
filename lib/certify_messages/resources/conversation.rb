module CertifyMessages
  # conversation class that handles getting and posting new conversations
  class Conversation < Resource
    # base conversation finder
    # rubocop:disable Metrics/AbcSize
    def self.find(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = conversation_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_find_conversations_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyMessages.service_unavailable error.class
    end

    # create a new conversation and a new message along with it
    def self.create(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = conversation_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_conversations_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      CertifyMessages.service_unavailable error.class
    end

    def self.create_with_message(params)
      combined_response = {}
      combined_response[:conversation] = create params
      combined_response[:message] = if combined_response[:conversation][:status] == 201
                                      message_params = parse_conversation_response combined_response[:conversation][:body], params
                                      CertifyMessages::Message.create message_params
                                    else
                                      return_response("An error occurred creating the conversation", 422)
                                    end
      combined_response
    end

    private_class_method

    def self.parse_conversation_response(response, params)
      params[:conversation_id] = response["id"]
      params
    end

    # helper for white listing parameters
    def self.conversation_safe_params(params)
      permitted_keys = %w[id subject application_id user_1 user_2]
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    def self.build_find_conversations_path(params)
      "#{path_prefix}/#{conversations_path}?#{URI.encode_www_form(params)}"
    end

    def self.build_create_conversations_path
      "#{path_prefix}/#{conversations_path}"
    end
  end
end
