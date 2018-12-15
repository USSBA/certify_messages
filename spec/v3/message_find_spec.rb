require 'spec_helper'
require 'support/v3/message_spec_helper'

module V3
  RSpec.describe "V3 CertifyMessages", type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 3
    end

    describe 'Getting messages', :vcr do
      context 'when getting messages' do
        let(:mock) { MessageSpecHelper.mock_messages_sym 1 }
        let(:messages) { CertifyMessages::Message.find(conversation_uuid: V3::MessageSpecHelper.mock_conversation_uuid) }

        it 'will have a ok status' do
          expect(messages[:status]).to eq(200)
        end
      end

      context 'when getting non-delegated message' do
        let(:mock) { MessageSpecHelper.mock_messages_sym 1 }
        let(:messages) { CertifyMessages::Message.find(conversation_uuid: "d8badb44-566e-4969-a1b4-784d6008bad8", uuid: "57efd9d1-86ea-46bb-8906-e95984c52505") }

        it 'will have a ok status' do
          expect(messages[:status]).to eq(200)
        end

        it 'will have has_delegate equal to false' do
          expect(messages[:body]['has_delegate']).to eq(false)
        end
      end

      context 'when getting delegate message' do
        let(:mock) { MessageSpecHelper.mock_messages_sym 1 }
        let(:messages) { CertifyMessages::Message.find(conversation_uuid: "d8badb44-566e-4969-a1b4-784d6008bad8", uuid: "2d7ec51c-e20c-4552-bc29-0e4047626ec4") }

        it 'will have a ok status' do
          expect(messages[:status]).to eq(200)
        end

        it 'will have has_delegate equal to true' do
          expect(messages[:body]['has_delegate']).to eq(true)
        end
      end

      context "with the priority_read_receipt_parameter" do
        let(:mock) do
          {
            conversation_uuid: V3::MessageSpecHelper.mock_conversation_uuid,
            priority_read_receipt: true
          }
        end
        let(:response) { CertifyMessages::Message.find(mock) }

        it "will return a 200 status" do
          expect(response[:status]).to eq(200)
        end
      end

      context "with no parameters for finding messages" do
        let(:messages) { CertifyMessages::Message.find }

        it "will return an error message when a bad parameter is sent" do
          expect(messages[:body]).to eq(CertifyMessages.bad_request[:body])
        end

        it "will return a 422 http status" do
          expect(messages[:status]).to eq(CertifyMessages.bad_request[:status])
        end
      end

      context "with bad parameters for finding messages" do
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
      context "when the api is not found", vcr: false do
        let(:bad_message) { CertifyMessages::Message.find(conversation_uuid: V3::MessageSpecHelper.mock_conversation_uuid) }
        let(:error_type) { "SocketError" }
        let(:error) { CertifyMessages.service_unavailable error_type }

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
          expect(bad_message[:status]).to eq(error[:status])
        end
        it "will return an error message" do
          expect(bad_message[:body]).to match(/#{error_type}/)
        end
      end
    end
  end
end
