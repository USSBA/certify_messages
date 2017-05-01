module CertifyMessages
  # conversation class that handles getting and posting new conversations
  class Conversation < Resource
    # base conversation finder
    # rubocop:disable Metrics/AbcSize
    def self.find(params)
      safe_params = conversation_safe_params params
      return return_response("Invalid parameters submitted", 400) if safe_params.empty? && !params_except_ac(params).empty?
      response = connection.request(method: :get,
                                    path: conversations_path + "?" +
                                    URI.encode_www_form(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
    end

    # create a new conversation and a new message along with it
    def self.create(params)
      safe_params = conversation_safe_params params
      return return_response("Invalid parameters submitted", 422) if safe_params.empty? || params_except_ac(params).empty?
      response = connection.request(method: :post,
                                    path: conversations_path,
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error::Socket => error
      return_response(error.message, 503)
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
      params[:sender_id] = params[:analyst_id]
      params[:recipient_id] = params[:contributor_id]
      params
    end

    # helper for white listing parameters
    def self.conversation_safe_params(params)
      permitted_keys = %w[id subject application_id analyst_id contributor_id]
      params = params.select { |key, _| permitted_keys.include? key.to_s }
    end
  end
end
