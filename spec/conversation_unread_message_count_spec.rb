require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
RSpec.describe CertifyMessages, type: :feature do
  describe "unread_message_counts operations in v1", :vcr do
    context "when getting message_counts" do
      let(:app_ids) { [1, 2].join(',') }
      let(:recipient_id) { 1 }
      let(:mock) { MessageSpecHelper.mock_unread_message_counts(app_ids, recipient_id) }
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_ids: app_ids, recipient_id: recipient_id}) }
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
      let(:app_ids) { [1, 2].join(',') }
      let(:recipient_id) { 1 }
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_ids: app_ids, recipient_id: recipient_id}) }
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

      it 'will return a 503' do
        expect(message_counts[:status]).to eq(error[:status])
      end

      it 'will return an error message' do
        expect(message_counts[:body]).to match(/#{error_type}/)
      end
    end
  end

  describe "unread_message_counts operations in v3", :vcr do
    before do
      CertifyMessages.configuration.msg_api_version = 3
    end

    context "when getting message_counts" do
      let(:app_uuids) { ['132ae1b3-734f-4313-a418-18667876fe56', '9c245408-baa0-4a64-b4ec-46f0b529b1b3'].join(',') }
      let(:recipient_uuid) { '16028520-03c5-4bcc-9e90-d826613a4166' }
      let(:mock) { MessageSpecHelper.mock_unread_message_counts_v3(app_uuids, recipient_uuid) }
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
      let(:app_uuids) { ['132ae1b3-734f-4313-a418-18667876fe56', '9c245408-baa0-4a64-b4ec-46f0b529b1b3'].join(',') }
      let(:recipient_uuid) { '16028520-03c5-4bcc-9e90-d826613a4166' }
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_uuids: app_uuids, recipient_uuid: recipient_uuid}) }
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

      it 'will return a 503' do
        expect(message_counts[:status]).to eq(error[:status])
      end

      it 'will return an error message' do
        expect(message_counts[:body]).to match(/#{error_type}/)
      end
    end

    after do
      CertifyMessages.configuration.msg_api_version = 1
    end
  end
end
#rubocop:enable Style/BracesAroundHashParameters
