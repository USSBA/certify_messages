# Creates mock hashes to be used in simulating messages and conversations
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
      mixed_keys: mock_conversation_mix
    }
  end

  def self.mock_conversation_sym
    { id: Faker::Number.number(10),
      application_id: Faker::Number.number(10),
      subject: Faker::StarWars.quote,
      user_1: Faker::Number.number(10),
      user_2: Faker::Number.number(10),
      created_date: Date.today,
      updated_date: Date.today }
  end

  def self.mock_conversation_string
    { "id" => Faker::Number.number(10),
      "application_id" => Faker::Number.number(10),
      "subject" => Faker::StarWars.quote,
      "user_1" => Faker::Number.number(10),
      "user_2" => Faker::Number.number(10),
      "created_date" => Date.today,
      "updated_date" => Date.today }
  end

  def self.mock_conversation_mix
    { id: Faker::Number.number(10),
      application_id: Faker::Number.number(10),
      "subject" => Faker::StarWars.quote,
      "user_1" => Faker::Number.number(10),
      user_2: Faker::Number.number(10),
      created_date: Date.today,
      updated_date: Date.today }
  end

  def self.mock_messages(owner)
    [ mock_message(1, 2, owner), mock_message(2, 1, owner), mock_message(1, 2, owner) ]
  end

  def self.mock_message(sender, recipient, owner)
    { message_id: Faker::Number.number(3),
      conversation_id: 1,
      "body" => Faker::StarWars.wookie_sentence,
      "sender_id" => sender,
      recipient_id: recipient,
      read: false,
      sent: false,
      created_at: Date.today,
      updated_at: Date.today,
      sender: owner == sender }
  end
end
