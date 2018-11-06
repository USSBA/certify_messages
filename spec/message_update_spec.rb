require 'spec_helper'

RSpec.describe CertifyMessages, type: :feature do
  describe 'Updating messages', :vcr do
    context 'with read/unread status' do
      let(:read_message) { MessageSpecHelper.mock_message_sym(1, 2, 1) }
      let(:params) { {id: 11, read: true, conversation_id: 2} }
      let(:updated_message_response) { CertifyMessages::Message.update(params) }

      it "will return an 200 status" do
        expect(updated_message_response[:body]['read']).to be(true)
      end
    end

    context "with no parameters for updating messages" do
      let(:messages) { CertifyMessages::Message.update }

      it "will return an error message when a bad parameter is sent" do
        expect(messages[:body]).to eq(CertifyMessages.bad_request[:body])
      end

      it "will return a 422 http status" do
        expect(messages[:status]).to eq(CertifyMessages.bad_request[:status])
      end
    end

    context "with bad parameters for updating messages" do
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
    context "when the api is not found", vcr: false do
      let(:bad_message) { CertifyMessages::Message.update(body: "foo") }
      let(:error_type) { "SocketError" }
      let(:error) { described_class.service_unavailable error_type }

      before do
        CertifyMessages::Resource.clear_connection
        CertifyMessages.configure do |message_config|
          message_config.api_url = "http://foo.bar"
        end
        # reextend the endpoint to a dummy url
      end

      after do
        CertifyMessages::Resource.clear_connection
        CertifyMessages.configure do |message_config|
          message_config.api_url = "http://localhost:3001"
        end
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
