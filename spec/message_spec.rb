require 'spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength

RSpec.describe CertifyMessages::Message do
  describe 'Getting messages' do
    context 'for getting messages' do
      before do
        @mock = MessageSpecHelper.mock_messages 1
        Excon.stub({}, body: @mock.to_json)
        @messages = CertifyMessages::Message.find(conversation_id: 1)[:body]
      end

      it 'should return an array of messages' do
        # puts(@messages[:body])
        expect(@messages.length).to be
        expect(@messages[0]["sender_id"]).to be
        expect(@messages[0]["recipient_id"]).to be
        expect(@messages[0]["body"]).to be
        expect(@messages[0]["created_at"]).to be
        expect(@messages[0]["conversation_id"]).to be
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

    # this will work if the API is disconnected, but I can't figure out how to
    # fake the Excon connection to force it to fail in a test env.
    context "api not found" do
      before do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = false
        # reextend the endpoint to a dummy url

        @bad_message = CertifyMessages::Message.find({conversation_id: 1})
      end

      after do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "should return a 503" do
        expect(@bad_message[:status]).to eq(503)
      end
    end
  end

  describe 'Creating messages' do
    context 'for creating valid new messages' do
      before do
        new_message = MessageSpecHelper.mock_message(1, 2, 1)
        Excon.stub({}, body: new_message.to_json, status: 201)
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

    # this will work if the API is disconnected, but I can't figure out how to
    # fake the Excon connection to force it to fail in a test env.
    context "api not found" do
      before do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = false
        @message_response = CertifyMessages::Message.create(MessageSpecHelper.mock_message(1, 2, 1))
      end

      after do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "should return a 503" do
        expect(@message_response[:status]).to eq(503)
      end
    end
  end
end
