require 'spec_helper'
require 'faker'

RSpec.describe CertifyMessages::Message do

  context 'for getting messages' do
    before do
      @mock = MessageSpecHelper.mock_messages 1
      Excon.stub({}, body: @mock.to_json)
      @messages = CertifyMessages::Message.find(conversation_id: 1)
    end
    it 'should return an array of messages' do
      expect(@messages.length).to be 3
      expect(@messages[0]["sender_id"]).to be 1
      expect(@messages[0]["recipient_id"]).to be 2
      expect(@messages[0]["body"].length).to be > 0
      expect(@messages[0]["created_at"].length).to be > 0
      expect(@messages[0]["conversation_id"]).to be 1
      expect(@messages[0]["read"]).to be false
      expect(@messages[0]["sent"]).to be false
    end
  end
  context "handles bad parameters" do
    before do
      @messages = CertifyMessages::Message.find(foo: 'bar')
    end
    it "should return an error message when a bad parameter is sent" do
      expect(@messages).to eq("Invalid parameters submitted")
    end
  end
end
