require 'spec_helper'

#rubocop:disable Metrics/BlockLength
RSpec.describe "CertifyMessages::Message.create", type: :feature do
  MessageSpecHelper.mock_message_types.each do |type, msg_mock|
    describe "Creating messages for #{type}" do
      context 'for creating valid new messages' do
        let(:new_message) { MessageSpecHelper.symbolize msg_mock }
        let(:new_message_response) { CertifyMessages::Message.create(new_message) }

        before { Excon.stub({}, body: new_message.to_json, status: 201) }
        it 'will return a status code of 201' do
          expect(new_message_response[:status]).to be 201
        end
      end

      context 'for attempting to create a message with no params' do
        let(:bad_message_response) { CertifyMessages::Message.create }

        it 'will return a status code of 400' do
          expect(bad_message_response[:status]).to eq(CertifyMessages.bad_request[:status])
        end

        it 'will return an error message' do
          expect(bad_message_response[:body]).to eq(CertifyMessages.bad_request[:body])
        end
      end

      context 'for attempting to create an invalid new message' do
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
      context "api not found" do
        let(:message_response) { CertifyMessages::Message.create(MessageSpecHelper.mock_message_sym(1, 2, 1)) }
        let(:error) { CertifyMessages.service_unavailable 'Excon::Error::Socket' }

        before do
          CertifyMessages::Resource.clear_connection
          Excon.defaults[:mock] = false
        end

        after do
          CertifyMessages::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "will return a 503" do
          expect(message_response[:status]).to eq(error[:status])
        end

        it "will return an error message" do
          expect(message_response[:body]).to eq(error[:body])
        end
      end
    end
  end
end
