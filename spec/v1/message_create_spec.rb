require 'spec_helper'

module V1
  RSpec.describe CertifyMessages, type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 1
    end

    MessageSpecHelper.mock_message_types.each do |type, msg_mock|
      describe "Creating messages for #{type}", :vcr do
        context 'when creating valid new messages' do
          let(:new_message_response) { CertifyMessages::Message.create(msg_mock) }

          it 'will return a status code of 201' do
            expect(new_message_response[:status]).to be 201
          end
        end

        context 'when attempting to create a message with no params' do
          let(:bad_message_response) { CertifyMessages::Message.create }

          it 'will return a status code of 400' do
            expect(bad_message_response[:status]).to eq(CertifyMessages.bad_request[:status])
          end

          it 'will return an error message' do
            expect(bad_message_response[:body]).to eq(CertifyMessages.bad_request[:body])
          end
        end

        context 'when attempting to create an invalid new message' do
          let(:bad_message_response) { CertifyMessages::Message.create(foo: 'bar') }

          it 'will return a status code of 422' do
            expect(bad_message_response[:status]).to eq(CertifyMessages.unprocessable[:status])
          end

          it 'will return an error message' do
            expect(bad_message_response[:body]).to eq(CertifyMessages.unprocessable[:body])
          end
        end

        # this will work if the API is disconnected, but I can't figure out how to
        # fake the Excon connection to force it to fail in a test env.
        context "when the api is not found", vcr: false do
          let(:message_response) { CertifyMessages::Message.create(MessageSpecHelper.mock_message_sym(1, 2, 1)) }
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
            expect(message_response[:status]).to eq(error[:status])
          end

          it "will return an error message" do
            expect(message_response[:body]).to match(/#{error_type}/)
          end
        end
      end
    end
  end
end
