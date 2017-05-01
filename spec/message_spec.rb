require 'spec_helper'

#rubocop:disable Metrics/BlockLength

RSpec.describe CertifyMessages::Message do
  describe 'Getting messages' do
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
    context "handles bad parameters for finding messages" do
      before do
        @messages = CertifyMessages::Message.find(foo: 'bar')
      end
      it "should return an error message when a bad parameter is sent" do
        expect(@messages[:body]).to eq("Invalid parameters submitted")
      end
      it "should return a 400 http status" do
        expect(@messages[:status]).to eq(400)
      end
    end
  end

  describe 'Creating messages' do
    context 'for creating valid new messages' do
      before do
        new_message = MessageSpecHelper.mock_message(1, 2, 1)
        Excon.stub({}, status: 201)
        @new_message_response = CertifyMessages::Message.create(new_message)
      end
      it 'should return a status code of 201' do
        expect(@new_message_response[:status]).to be 201
      end
    end

    context 'for attempting to create an invalid new message' do
      before do
        @bad_message_response = CertifyMessages::Message.create(foo: 'bar')
      end
      it 'should return a status code of 422' do
        expect(@bad_message_response[:status]).to be 422
      end
      it 'should return an error message' do
        expect(@bad_message_response[:body]).to eq "Invalid parameters submitted"
      end
    end
  end
end
