require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe CertifyMessages, type: :feature do
  describe "unread_message_counts operations" do
    context "for getting message_counts" do
      let(:app_ids) { [1, 2] }
      let(:recipient_id) { 1 }
      let(:mock) { MessageSpecHelper.mock_unread_message_counts(app_ids, recipient_id) }
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_ids: app_ids, recipient_id: recipient_id}) }
      let(:body) { message_counts[:body] }

      before { Excon.stub({}, body: mock.to_json, status: 200) }

      it "will return a good status code" do
        expect(message_counts[:status]).to eq(200)
      end

      it 'will contain applications array' do
        expect(body['applications'].length).to eq 2
      end
      it 'will contain valid message_counts' do
        expect(body['applications'][0]['unread_message_count']).to eq 5
      end
    end

    context "handles errors: no params" do
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts }
      let(:body) { message_counts[:body] }

      it 'will return an error message' do
        expect(body).to eq(CertifyMessages.bad_request[:body])
      end
      it 'will return a 400' do
        expect(message_counts[:status]).to eq(CertifyMessages.bad_request[:status])
      end
    end

    context 'handles errors: bad parameters' do
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({foo: 'bar'}) }
      let(:body) { message_counts[:body] }

      it 'will return an error message when a bad parameter is sent' do
        expect(body).to eq(CertifyMessages.unprocessable[:body])
      end

      it 'will return a 422 http status' do
        expect(message_counts[:status]).to eq(CertifyMessages.unprocessable[:status])
      end
    end

    context 'handles errors: api not found' do
      let(:app_ids) { [1, 2] }
      let(:recipient_id) { 1 }
      let(:message_counts) { CertifyMessages::Conversation.unread_message_counts({application_ids: app_ids, recipient_id: recipient_id}) }
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

      it 'will return a 503' do
        expect(message_counts[:status]).to eq(error[:status])
      end

      it 'will return an error message' do
        expect(message_counts[:body]).to match(/#{error_type}/)
      end
    end
  end
end