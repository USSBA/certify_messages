require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
RSpec.describe CertifyMessages, type: :feature do
  describe "find operations" do
    context "when getting conversations" do
      let(:mock) { MessageSpecHelper.mock_conversation_sym }
      let(:conversations) { CertifyMessages::Conversation.find({application_id: 1}) }
      let(:body) { conversations[:body] }

      before { Excon.stub({}, body: mock.to_json, status: 200) }

      it "will return a good status code" do
        expect(conversations[:status]).to eq(200)
      end

      it "will return an array of conversations" do
        expect(body.length).to be > 0
      end

      it 'will contain valid conversation attributes ["user_1"]' do
        expect(body["user_1"]).to be
      end
      it 'will contain valid conversation attributes ["application_id"]' do
        expect(body["application_id"]).to be
      end
      it 'will contain valid conversation attributes ["user_2"]' do
        expect(body["user_2"]).to be
      end
      it 'will contain valid conversation attributes ["id"]' do
        expect(body["id"]).to be
      end
      it 'will contain valid conversation attributes ["subject"]' do
        expect(body["subject"]).to be
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

    context "when the api is not found" do
      let(:conversations) { CertifyMessages::Conversation.find({application_id: 1}) }
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
        expect(conversations[:status]).to eq(error[:status])
      end

      it "will return an error message" do
        expect(conversations[:body]).to match(/#{error_type}/)
      end
    end
  end
end
#rubocop:enable Style/BracesAroundHashParameters
