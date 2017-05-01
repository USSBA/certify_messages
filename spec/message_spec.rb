require 'spec_helper'
require 'faker'

RSpec.describe CertifyMessages::Message do

  def mock_messages(owner)
    [ mock_message(1, 2, owner), mock_message(2, 1, owner), mock_message(1, 2, owner) ]
  end


  def mock_message(sender, recipient, owner)
    { message_id: Faker::Number.number(3),
      conversation_id: 1,
      body: @body,
      sender_id: sender,
      recipient_id: recipient,
      read: false,
      sent: false,
      created_at: @created_time,
      # updated_at: Faker::Time.between(2.days.ago, Date.today, :all).to_s,
      sender: owner == sender }
  end

  context 'for getting messages' do
    before do
      @body = Faker::StarWars.wookie_sentence
      @created_time = Faker::Time.between(DateTime.now - 1, DateTime.now).to_s
      @mock = mock_messages 1
      Excon.stub({}, body: @mock.to_json)
      @messages = CertifyMessages::Message.find({conversation_id: 1})
    end
    it 'should return an array of messages' do
      expect(@messages.length).to be 3
      expect(@messages[0]["sender_id"]).to be 1
      expect(@messages[0]["recipient_id"]).to be 2
      expect(@messages[0]["body"]).to eq @body
      expect(@messages[0]["created_at"]).to eq @created_time
      expect(@messages[0]["conversation_id"]).to be 1
      expect(@messages[0]["read"]).to be false
      expect(@messages[0]["sent"]).to be false
    end
  end
  context "handles bad parameters" do
    before do
      @messages = CertifyMessages::Message.find({foo: 'bar'})
    end
    it "should return an error message when a bad parameter is sent" do
      expect(@messages).to eq("Invalid parameters submitted")
    end
  end
end
