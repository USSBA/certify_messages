module CertifyMessages
  # conversation class that handles getting and posting new conversations
  # rubocop:disable Metrics/ClassLength
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
      handle_excon_error(error)
    end

    # create a new conversation and a new message along with it
    def self.create(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = conversation_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :post,
                                    path: build_create_conversations_path,
                                    body: safe_params.to_json,
                                    headers: { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
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

    def self.unread_message_counts(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      safe_params = unread_message_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_unread_message_counts_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    # rubocop:disable Metrics/MethodLength
    def self.archive(params = nil)
      return CertifyMessages.bad_request if empty_params(params)
      return CertifyMessages.bad_request unless conversation_param_included(params)
      update_path = build_update_conversations_path(params)
      safe_params = archive_conversation_safe_params params
      return CertifyMessages.unprocessable if safe_params.empty?
      response = connection.request(method: :put,
                                    path: update_path,
                                    body: safe_params.to_json,
                                    headers: { "Content-Type" => "application/json" })
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private_class_method

    def self.parse_conversation_response(response, params)
      if msg_api_version == 3
        params[:conversation_uuid] = response["uuid"]
      else
        params[:conversation_id] = response["id"]
      end
      params
    end

    # helper for white listing parameters
    def self.conversation_safe_params(params)
      params = sanitize_params params
      permitted_keys_v1 = %w[id application_id user_1 user_2]
      permitted_keys_v3 = %w[conversation_uuid application_uuid user1_uuid user2_uuid]
      permitted_keys = %w[subject conversation_type archived include_archived order]
      # NOTE: ternary statement will need to be replaced once we have more than two versions to support
      msg_api_version == 3 ? permitted_keys.push(*permitted_keys_v3) : permitted_keys.push(*permitted_keys_v1)
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    # helper for white listing parameters
    def self.archive_conversation_safe_params(params)
      params = sanitize_params params
      permitted_keys_v1 = %w[conversation_id]
      permitted_keys_v3 = %w[conversation_uuid]
      permitted_keys = %w[archived]
      # NOTE: ternary statement will need to be replaced once we have more than two versions to support
      msg_api_version == 3 ? permitted_keys.push(*permitted_keys_v3) : permitted_keys.push(*permitted_keys_v1)
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    def self.unread_message_params(params)
      params = sanitize_params params
      # NOTE: ternary statement will need to be replaced once we have more than two versions to support
      permitted_keys = msg_api_version == 3 ? %w[application_uuid recipient_uuid] : %w[application_ids recipient_id]
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    def self.sanitize_params(params)
      # rebuild params as symbols, dropping ones as strings
      sanitized_params = {}
      params.each do |key, value|
        if key.is_a? String
          sanitized_params[key.to_sym] = value
        else
          sanitized_params[key] = value
        end
      end
      sanitized_params
    end

    def self.build_find_conversations_path(params)
      "#{path_prefix}/#{conversations_path}?#{URI.encode_www_form(params)}"
    end

    def self.build_create_conversations_path
      "#{path_prefix}/#{conversations_path}"
    end

    def self.build_update_conversations_path(params)
      "#{path_prefix}/#{conversations_path}/#{conversation_param_value(params)}"
    end

    def self.build_unread_message_counts_path(params)
      "#{path_prefix}/#{unread_message_counts_path}?#{URI.encode_www_form(params)}"
    end
  end
  # rubocop:enable Metrics/ClassLength
end
