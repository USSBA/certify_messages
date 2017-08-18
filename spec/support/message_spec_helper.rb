# Creates mock hashes to be used in simulating messages and conversations
module MessageSpecHelper
  def self.json
    JSON.parse(response.body)
  end

  def self.mock_conversations
    [mock_conversation, mock_conversation, mock_conversation]
  end

  def self.mock_conversation
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
