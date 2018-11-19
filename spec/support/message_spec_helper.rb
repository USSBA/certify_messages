# Creates mock hashes to be used in simulating messages and conversations
# rubocop:disable Metrics/ModuleLength
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
      user_1: Faker::Number.number(4),
      user_2: Faker::Number.number(4),
      created_date: Date.today,
      updated_date: Date.today }
  end

  def self.mock_conversation_string
    { "application_id" => Faker::Number.number(4),
      "subject" => Faker::StarWars.quote,
      "user_1" => Faker::Number.number(4),
      "user_2" => Faker::Number.number(4),
      "created_date" => Date.today,
      "updated_date" => Date.today }
  end

  def self.mock_conversation_mixed
    { application_id: Faker::Number.number(4),
      "subject" => Faker::StarWars.quote,
      "user_1" => Faker::Number.number(4),
      user_2: Faker::Number.number(4),
      created_date: Date.today,
      updated_date: Date.today }
  end

  # mocks for messages
  def self.mock_messages_sym(owner)
    [mock_message_sym(1, 2, owner), mock_message_sym(2, 1, owner), mock_message_sym(1, 2, owner)]
  end

  # messages can be parameterized with keys as symbols, keys as strings or a mix of symbols and strings
  def self.mock_message_types
    {
      symbol_keys: mock_message_sym(1000, 2000, 1000),
      string_keys: mock_message_string(1000, 2000, 1000),
      mixed_keys: mock_message_mixed(1000, 2000, 1000)
    }
  end

  # rubocop:disable Metrics/MethodLength
  def self.mock_message_sym(sender, recipient, owner)
    { message_id: Faker::Number.number(3),
      conversation_id: 10,
      body: Faker::StarWars.wookie_sentence,
      sender_id: sender,
      recipient_id: recipient,
      read: false,
      sent: false,
      created_at: Date.today,
      updated_at: Date.today,
      sender: owner == sender,
      priority_read_receipt: true }
  end

  def self.mock_message_sym_v3(sender, recipient, owner)
    { message_uuid: "b3edf1aa-c34f-49df-9bb1-4d189fd63cb2",
      conversation_uuid: "ba057fb5-8447-429e-a5e5-94764963cb16",
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
  # rubocop:enable Metrics/MethodLength

  def self.mock_message_string(sender, recipient, owner)
    { "message_id" => Faker::Number.number(3),
      "conversation_id" => 10,
      "body" => Faker::StarWars.wookie_sentence,
      "sender_id" => sender,
      "recipient_id" => recipient,
      "read" => false,
      "sent" => false,
      "created_at" => Date.today,
      "updated_at" => Date.today,
      "sender" => owner == sender }
  end

  def self.mock_message_mixed(sender, recipient, owner)
    { message_id: Faker::Number.number(3),
      "conversation_id" => 10,
      "body" => Faker::StarWars.wookie_sentence,
      sender_id: sender,
      recipient_id: recipient,
      read: false,
      sent: false,
      created_at: Date.today,
      updated_at: Date.today,
      sender: owner == sender }
  end

  def self.mock_unread_message_counts(application_ids, recipient_id)
    counts = application_ids.split(',').map do |app_id|
      { application_id: app_id.to_i,
        recipient_id: recipient_id,
        unread_message_count: 5 }
    end

    { applications: counts }
  end

  def self.mock_unread_message_counts_v3(application_uuids, recipient_uuid)
    counts = application_uuids.split(',').map do |app_uuid|
      { application_uuid: app_uuid,
        recipient_uuid: recipient_uuid,
        unread_message_count: 5 }
    end

    { applications: counts }
  end
end
# rubocop:enable Metrics/ModuleLength
