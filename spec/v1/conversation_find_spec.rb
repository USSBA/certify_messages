require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
module V1
  RSpec.describe CertifyMessages, type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 1
    end

    describe "find operations", :vcr do
      context "when getting conversations" do
        let(:conversations) { CertifyMessages::Conversation.find({application_id: 1}) }
        let(:body) { conversations[:body] }

        it "will return a good status code" do
          expect(conversations[:status]).to eq(200)
        end
      end

      context "with no params" do
        let(:conversations) { CertifyMessages::Conversation.find }
        let(:body) { conversations[:body] }

        it "will return an error message}" do
          expect(body).to eq(CertifyMessages.bad_request[:body])
        end
        it "will return a 400" do
          expect(conversations[:status]).to eq(CertifyMessages.bad_request[:status])
        end
      end

      context "with bad parameters" do
        let(:conversations) { CertifyMessages::Conversation.find({foo: 'bar'}) }
        let(:body) { conversations[:body] }

        it "will return an error message when a bad parameter is sent" do
          expect(body).to eq(CertifyMessages.unprocessable[:body])
        end

        it "will return a 422 http status" do
          expect(conversations[:status]).to eq(CertifyMessages.unprocessable[:status])
        end
      end

      context "when the api is not found", vcr: false do
        let(:conversations) { CertifyMessages::Conversation.find({application_id: 1}) }
        let(:error_type) { "SocketError" }
        let(:error) { described_class.service_unavailable error_type }

        before do
          CertifyMessages::Resource.clear_connection
          CertifyMessages.configure do |message_config|
            message_config.api_url = "http://foo.bar"
          end
        end

        after do
          CertifyMessages::Resource.clear_connection
          CertifyMessages.configure do |message_config|
            message_config.api_url = "http://localhost:3001"
          end
        end

        it "will return a 503" do
          expect(conversations[:status]).to eq(error[:status])
        end

        it "will return an error message" do
          expect(conversations[:body]).to match(/#{error_type}/)
        end
      end
    end
  end
end
#rubocop:enable Style/BracesAroundHashParameters
