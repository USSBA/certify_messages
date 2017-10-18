require 'spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength

RSpec.describe "CertifyMessages::Message.find", type: :feature do
  describe 'Getting messages' do
    context 'for getting messages' do
      let(:mock) { MessageSpecHelper.mock_messages_sym 1 }
      let(:messages) { CertifyMessages::Message.find(conversation_id: 1)[:body] }

      before { Excon.stub({}, body: mock.to_json) }

      it 'will have messages' do
        expect(messages.length).to be
      end
      it 'will have the correct attributes "sender_id"' do
        expect(messages[0]["sender_id"]).to be
      end
      it 'will have the correct attributes "recipient_id"' do
        expect(messages[0]["recipient_id"]).to be
      end
      it 'will have the correct attributes "body"' do
        expect(messages[0]["body"]).to be
      end
      it 'will have the correct attributes "created_at"' do
        expect(messages[0]["created_at"]).to be
      end
      it 'will have the correct attributes "conversation_id"' do
        expect(messages[0]["conversation_id"]).to be
      end
      it 'will have the correct attributes "read"' do
        expect(messages[0]["read"]).to be false
      end
      it 'will have the correct attributes "sent"' do
        expect(messages[0]["sent"]).to be false
      end
      it 'will have the correct attributes "priority_read_receipt"' do
        expect(messages[0]["priority_read_receipt"]).to be true
      end
    end

    context "HUB-908 allows the priority_read_receipt_parameter" do
      let(:mock) { MessageSpecHelper.mock_conversation_sym }
      let(:response) { CertifyMessages::Message.find(priority_read_receipt: true) }

      before { Excon.stub({}, body: mock.to_json) }

      it "will return a message" do
        expect(response[:body][:priority_read_receipt]).to eq(mock[:priority_read_receipt])
      end

      it "will return a 200 status" do
        expect(response[:status]).to eq(200)
      end
    end

    context "handles no parameters for finding messages" do
      let(:messages) { CertifyMessages::Message.find }

      it "will return an error message when a bad parameter is sent" do
        expect(messages[:body]).to eq(CertifyMessages.bad_request[:body])
      end

      it "will return a 422 http status" do
        expect(messages[:status]).to eq(CertifyMessages.bad_request[:status])
      end
    end

    context "handles bad parameters for finding messages" do
      let(:messages) { CertifyMessages::Message.find(foo: 'bar') }

      it "will return an error message when a bad parameter is sent" do
        expect(messages[:body]).to eq(CertifyMessages.unprocessable[:body])
      end

      it "will return a 422 http status" do
        expect(messages[:status]).to eq(CertifyMessages.unprocessable[:status])
      end
    end

    # this will work if the API is disconnected, but I can't figure out how to
    # fake the Excon connection to force it to fail in a test env.
    context "api not found" do
      let(:bad_message) { CertifyMessages::Message.find({conversation_id: 1}) }
      let(:error) { CertifyMessages.service_unavailable 'Excon::Error::Socket' }

      before do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = false
        # reextend the endpoint to a dummy url
      end

      after do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "will return a 503" do
        expect(bad_message[:status]).to eq(error[:status])
      end
      it "will return an error message" do
        expect(bad_message[:body]).to eq(error[:body])
      end
    end
  end
end
