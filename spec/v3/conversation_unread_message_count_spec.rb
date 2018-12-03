require 'spec_helper'
require 'support/v3/message_spec_helper'

#rubocop:disable Style/BracesAroundHashParameters
module V3
  RSpec.describe "V3 CertifyMessages", type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 3
    end

    describe "unread_message_counts operations", :vcr do
      context "when getting message_counts" do
        let(:app_uuids) { [V3::MessageSpecHelper.mock_user1_uuid, V3::MessageSpecHelper.mock_user2_uuid].join(',') }
        let(:recipient_uuid) { V3::MessageSpecHelper.mock_user1_uuid }
        let(:mock) { MessageSpecHelper.mock_unread_message_counts(app_uuids, recipient_uuid) }
        let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_uuids: app_uuids, recipient_uuid: recipient_uuid}) }
        let(:body) { message_counts[:body] }

        it "will return a good status code" do
          expect(message_counts[:status]).to eq(200)
        end
      end

      context "with no params" do
        let(:message_counts) { CertifyMessages::Conversation.unread_message_counts }
        let(:body) { message_counts[:body] }

        it 'will return an error message' do
          expect(body).to eq(CertifyMessages.bad_request[:body])
        end
        it 'will return a 400' do
          expect(message_counts[:status]).to eq(CertifyMessages.bad_request[:status])
        end
      end

      context 'with bad parameters' do
        let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({foo: 'bar'}) }
        let(:body) { message_counts[:body] }

        it 'will return an error message when a bad parameter is sent' do
          expect(body).to eq(CertifyMessages.unprocessable[:body])
        end

        it 'will return a 422 http status' do
          expect(message_counts[:status]).to eq(CertifyMessages.unprocessable[:status])
        end
      end

      context 'when the api is not found', vcr: false do
        let(:app_uuids) { [V3::MessageSpecHelper.mock_user1_uuid, V3::MessageSpecHelper.mock_user2_uuid].join(',') }
        let(:recipient_uuid) { V3::MessageSpecHelper.mock_user1_uuid }
        let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_uuids: app_uuids, recipient_uuid: recipient_uuid}) }
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

        it 'will return a 503' do
          expect(message_counts[:status]).to eq(error[:status])
        end

        it 'will return an error message' do
          expect(message_counts[:body]).to match(/#{error_type}/)
        end
      end
    end
  end
end
#rubocop:enable Style/BracesAroundHashParameters
