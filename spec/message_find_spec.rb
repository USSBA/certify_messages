require 'spec_helper'

RSpec.describe CertifyMessages, type: :feature do
  describe 'Getting messages in v1', :vcr do
    context 'when getting messages' do
      let(:mock) { MessageSpecHelper.mock_messages_sym 1 }
      let(:messages) { CertifyMessages::Message.find(conversation_id: 1) }

      it 'will have a ok status' do
        expect(messages[:status]).to be 200
      end
    end

    context "with the priority_read_receipt_parameter" do
      let(:mock) do
        {
          conversation_id: 1,
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
      let(:bad_message) { CertifyMessages::Message.find(conversation_id: 1) }
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
        expect(bad_message[:status]).to eq(error[:status])
      end
      it "will return an error message" do
        expect(bad_message[:body]).to match(/#{error_type}/)
      end
    end
  end

  describe "Getting messages in v3", :vcr do
    before do
      CertifyMessages.configuration.msg_api_version = 3
    end

    context 'when getting messages' do
      let(:mock) { MessageSpecHelper.mock_messages_sym 1 }
      let(:messages) { CertifyMessages::Message.find(conversation_uuid: "de891425-de6a-41b9-90e3-0b3e1edd5807") }

      it 'will have a ok status' do
        expect(messages[:status]).to be 200
      end
    end

    context "with the priority_read_receipt_parameter" do
      let(:mock) do
        {
          conversation_uuid: "de891425-de6a-41b9-90e3-0b3e1edd5807",
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
      let(:bad_message) { CertifyMessages::Message.find(conversation_uuid: "de891425-de6a-41b9-90e3-0b3e1edd5807") }
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
        expect(bad_message[:status]).to eq(error[:status])
      end
      it "will return an error message" do
        expect(bad_message[:body]).to match(/#{error_type}/)
      end
    end

    after do
      CertifyMessages.configuration.msg_api_version = 1
    end
  end
end
