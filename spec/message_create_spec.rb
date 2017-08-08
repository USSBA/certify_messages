require 'spec_helper'

#rubocop:disable Metrics/BlockLength

RSpec.describe "CertifyMessages::Message.create", type: :feature do
  describe 'Creating messages' do
    context 'for creating valid new messages' do
      before do
        new_message = MessageSpecHelper.mock_message(1, 2, 1)
        Excon.stub({}, body: new_message.to_json, status: 201)
        @new_message_response = CertifyMessages::Message.create(new_message)
      end

      it 'will return a status code of 201' do
        expect(@new_message_response[:status]).to be 201
      end
    end

    context 'for attempting to create a message with no params' do
      before do
        @bad_message_response = CertifyMessages::Message.create
      end

      it 'will return a status code of 400' do
        expect(@bad_message_response[:status]).to eq(CertifyMessages.bad_request[:status])
      end

      it 'will return an error message' do
        expect(@bad_message_response[:body]).to eq(CertifyMessages.bad_request[:body])
      end
    end

    context 'for attempting to create an invalid new message' do
      before do
        @bad_message_response = CertifyMessages::Message.create(foo: 'bar')
      end

      it 'will return a status code of 422' do
        expect(@bad_message_response[:status]).to eq(CertifyMessages.unprocessable[:status])
      end

      it 'will return an error message' do
        expect(@bad_message_response[:body]).to eq(CertifyMessages.unprocessable[:body])
      end
    end

    # this will work if the API is disconnected, but I can't figure out how to
    # fake the Excon connection to force it to fail in a test env.
    context "api not found" do
      before do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = false
        @message_response = CertifyMessages::Message.create(MessageSpecHelper.mock_message(1, 2, 1))
        @error = CertifyMessages.service_unavailable 'Excon::Error::Socket'
      end

      after do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "will return a 503" do
        expect(@message_response[:status]).to eq(@error[:status])
      end

      it "will return an error message" do
        expect(@message_response[:body]).to eq(@error[:body])
      end
    end
  end
end
