require 'spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength

RSpec.describe "CertifyMessages::Message.find", type: :feature do
  describe 'Getting messages' do
    context 'for getting messages' do
      before do
        @mock = MessageSpecHelper.mock_messages 1
        Excon.stub({}, body: @mock.to_json)
        @messages = CertifyMessages::Message.find(conversation_id: 1)[:body]
      end

      it 'will return an array of messages' do
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

    context "handles no parameters for finding messages" do
      before do
        @messages = CertifyMessages::Message.find
      end

      it "will return an error message when a bad parameter is sent" do
        expect(@messages[:body]).to eq(CertifyMessages.bad_request[:body])
      end

      it "will return a 422 http status" do
        expect(@messages[:status]).to eq(CertifyMessages.bad_request[:status])
      end
    end

    context "handles bad parameters for finding messages" do
      before do
        @messages = CertifyMessages::Message.find(foo: 'bar')
      end

      it "will return an error message when a bad parameter is sent" do
        expect(@messages[:body]).to eq(CertifyMessages.unprocessable[:body])
      end

      it "will return a 422 http status" do
        expect(@messages[:status]).to eq(CertifyMessages.unprocessable[:status])
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
        @error = CertifyMessages.service_unavailable 'Excon::Error::Socket'
      end

      after do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "will return a 503" do
        expect(@bad_message[:status]).to eq(@error[:status])
      end
      it "will return an error message" do
        expect(@bad_message[:body]).to eq(@error[:body])
      end
    end
  end
end
