# Creates mock hashes to be used in simulating messages and conversations
# rubocop:disable Metrics/ModuleLength
module V2
  module MessageSpecHelper
    def self.json
      JSON.parse(response.body)
    end

    def self.mock_conversations
      [mock_conversation_sym, mock_conversation_sym, mock_conversation_sym]
    end

    # helper to replace the rails symbolize_keys method
    def self.symbolize(hash)
      hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end

    def self.mock_user1_uuid
      "cc2cc3d7-1bfe-44ac-8cbe-ff15403299eb"
    end

    def self.mock_user2_uuid
      "08d64f43-a326-498d-9d9a-4b03f1ff486b"
    end

    def self.mock_author1_uuid
      "2d7ec51c-e20c-4552-bc29-0e4047626ec4"
    end

    def self.mock_author2_uuid
      "d7ebe2fa-f67a-4431-817a-6574b8dab412"
    end

    def self.mock_conversation_uuid
      "d8badb44-566e-4969-a1b4-784d6008bad8"
    end

    def self.mock_message_uuid
      "2d7ec51c-e20c-4552-bc29-0e4047626ec4"
    end

    def self.mock_application_id
      10
    end

    def self.mock_conversation_params
      {
        uuid: mock_conversation_uuid,
        user1_uuid: mock_user1_uuid,
        user2_uuid: mock_user2_uuid,
        application_id: mock_application_id,
        subject: Faker::StarWars.quote
      }
    end

    def self.mock_message_params
      {
        uuid: mock_message_uuid,
        conversation_uuid: mock_conversation_uuid,
        body: Faker::StarWars.wookie_sentence,
        sender_uuid: mock_user1_uuid,
        recipient_uuid: mock_user2_uuid
      }
    end

    def self.mock_delegate_message_params
      {
        uuid: mock_message_uuid,
        conversation_uuid: mock_conversation_uuid,
        body: Faker::StarWars.wookie_sentence,
        sender_uuid: mock_user1_uuid,
        recipient_uuid: mock_user2_uuid,
        author_uuid: mock_author1_uuid
      }
    end

    # conversations can be parameterized with keys as symbols, keys as strings or a mix of symbols and strings
    def self.mock_conversation_types
      {
        symbol_keys: mock_conversation_sym,
        string_keys: mock_conversation_string,
        mixed_keys: mock_conversation_mixed
      }
    end

    def self.mock_conversation_sym
      { application_id: Faker::Number.number(4),
        subject: Faker::StarWars.quote,
        user1_uuid: SecureRandom.uuid,
        user2_uuid: SecureRandom.uuid,
        created_date: Date.today,
        updated_date: Date.today }
    end

    def self.mock_conversation_string
      { "application_id" => Faker::Number.number(4),
        "subject" => Faker::StarWars.quote,
        "user1_uuid" => SecureRandom.uuid,
        "user2_uuid" => SecureRandom.uuid,
        "created_date" => Date.today,
        "updated_date" => Date.today }
    end

    def self.mock_conversation_mixed
      { application_id: Faker::Number.number(4),
        "subject" => Faker::StarWars.quote,
        "user1_uuid" => SecureRandom.uuid,
        user2_uuid: SecureRandom.uuid,
        created_date: Date.today,
        updated_date: Date.today }
    end

    # mocks for messages
    def self.mock_messages_sym(owner)
      [
        mock_message_sym(mock_user1_uuid, mock_user2_uuid, owner),
        mock_message_sym(mock_user2_uuid, mock_user1_uuid, owner),
        mock_message_sym(mock_user1_uuid, mock_user2_uuid, owner)
      ]
    end

    # mocks for messages
    def self.mock_delegate_messages_sym
      [
        mock_delegate_message_sym(mock_user1_uuid, mock_user2_uuid, mock_author2_uuid),
        mock_delegate_message_sym(mock_user2_uuid, mock_user1_uuid, mock_author2_uuid)
      ]
    end

    # messages can be parameterized with keys as symbols, keys as strings or a mix of symbols and strings
    # TODO: make messages using delegates
    def self.mock_message_types
      {
        symbol_keys: mock_message_sym(mock_user1_uuid, mock_user2_uuid, mock_user1_uuid),
        string_keys: mock_message_string(mock_user1_uuid, mock_user2_uuid, mock_user1_uuid),
        mixed_keys: mock_message_mixed(mock_user1_uuid, mock_user2_uuid, mock_user1_uuid)
      }
    end

    # messages can be parameterized with keys as symbols, keys as strings or a mix of symbols and strings
    # TODO: make messages using delegates
    def self.mock_delegate_message_types
      {
        symbol_keys: mock_delegate_message_sym(mock_user1_uuid, mock_user2_uuid, mock_author2_uuid),
        string_keys: mock_delegate_message_string(mock_user1_uuid, mock_user2_uuid, mock_author2_uuid),
        mixed_keys: mock_delegate_message_mixed(mock_user1_uuid, mock_user2_uuid, mock_author2_uuid)
      }
    end

    # rubocop:disable Metrics/MethodLength
    def self.mock_message_sym(sender, recipient, owner)
      { uuid: SecureRandom.uuid,
        conversation_uuid: mock_conversation_uuid,
        body: Faker::StarWars.wookie_sentence,
        sender_uuid: sender,
        recipient_uuid: recipient,
        read: false,
        sent: false,
        created_at: Date.today,
        updated_at: Date.today,
        sender: owner == sender,
        priority_read_receipt: true }
    end

    def self.mock_message_string(sender, recipient, owner)
      { "message_uuid" => SecureRandom.uuid,
        "conversation_uuid" => mock_conversation_uuid,
        "body" => Faker::StarWars.wookie_sentence,
        "sender_uuid" => sender,
        "recipient_uuid" => recipient,
        "read" => false,
        "sent" => false,
        "created_at" => Date.today,
        "updated_at" => Date.today,
        "sender" => owner == sender,
        "priority_read_receipt" => true }
    end

    def self.mock_message_mixed(sender, recipient, owner)
      { message_uuid: SecureRandom.uuid,
        "conversation_uuid" => mock_conversation_uuid,
        "body" => Faker::StarWars.wookie_sentence,
        sender_uuid: sender,
        recipient_uuid: recipient,
        read: false,
        sent: false,
        created_at: Date.today,
        updated_at: Date.today,
        sender: owner == sender,
        "priority_read_receipt" => true }
    end

    def self.mock_delegate_message_sym(sender, recipient, delegate)
      { uuid: SecureRandom.uuid,
        conversation_uuid: mock_conversation_uuid,
        body: Faker::StarWars.wookie_sentence,
        sender_uuid: sender,
        recipient_uuid: recipient,
        author_uuid: delegate,
        read: false,
        sent: false,
        created_at: Date.today,
        updated_at: Date.today,
        sender: delegate == sender,
        priority_read_receipt: true }
    end

    def self.mock_delegate_message_string(sender, recipient, delegate)
      { "message_uuid" => SecureRandom.uuid,
        "conversation_uuid" => mock_conversation_uuid,
        "body" => Faker::StarWars.wookie_sentence,
        "sender_uuid" => sender,
        "recipient_uuid" => recipient,
        "author_uuid" => delegate,
        "read" => false,
        "sent" => false,
        "created_at" => Date.today,
        "updated_at" => Date.today,
        "sender" => delegate == sender,
        "priority_read_receipt" => true }
    end

    def self.mock_delegate_message_mixed(sender, recipient, delegate)
      { message_uuid: SecureRandom.uuid,
        "conversation_uuid" => mock_conversation_uuid,
        "body" => Faker::StarWars.wookie_sentence,
        sender_uuid: sender,
        recipient_uuid: recipient,
        author_uuid: delegate,
        read: false,
        sent: false,
        created_at: Date.today,
        updated_at: Date.today,
        sender: delegate == sender,
        "priority_read_receipt" => true }
    end
    # rubocop:enable Metrics/MethodLength

    def self.mock_unread_message_counts(application_ids, recipient_uuid)
      counts = application_ids.split(',').map do |app_id|
        { application_id: app_id,
          recipient_uuid: recipient_uuid,
          unread_message_count: 5 }
      end

      { applications: counts }
    end
  end
end
# rubocop:enable Metrics/ModuleLength
