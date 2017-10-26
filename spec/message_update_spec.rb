require 'spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength

RSpec.describe CertifyMessages, type: :feature do
  describe 'Updating messages' do
    context 'for editing message read/unread status' do
      let(:read_message) { MessageSpecHelper.mock_message_sym(1, 2, 1) }
      let(:params) { {id: read_message[:id], read: read_message[:read], conversation_id: read_message[:conversation_id]} }
      let(:updated_message_response) { CertifyMessages::Message.update(params) }

      before do
        read_message[:read] = true
        Excon.stub({}, body: read_message.to_json, status: 201)
      end

      it "will return a message" do
        expect(updated_message_response[:body]['read']).to be(true)
      end
    end

    context "handles no parameters for updating messages" do
      let(:messages) { CertifyMessages::Message.update }

      it "will return an error message when a bad parameter is sent" do
        expect(messages[:body]).to eq(CertifyMessages.bad_request[:body])
      end

      it "will return a 422 http status" do
        expect(messages[:status]).to eq(CertifyMessages.bad_request[:status])
      end
    end

    context "handles bad parameters for updating messages" do
      let(:messages) { CertifyMessages::Message.update(foo: 'bar') }

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
      let(:bad_message) { CertifyMessages::Message.update({body: "foo"}) }
      let(:error_type) { "SocketError" }
      let(:error) { described_class.service_unavailable error_type }

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
        expect(bad_message[:body]).to match(/#{error_type}/)
      end
    end
  end
end
