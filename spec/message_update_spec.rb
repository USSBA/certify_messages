require 'spec_helper'

#rubocop:disable  Style/BracesAroundHashParameters, Metrics/BlockLength

RSpec.describe "CertifyMessages::Message.update", type: :feature do
  describe 'Updating messages' do
    context 'for editing message read/unread status' do
      before do
        read_message = MessageSpecHelper.mock_message(1, 2, 1)
        read_message[:read] = true
        Excon.stub({}, body: read_message.to_json, status: 201)
        @updated_message_response = CertifyMessages::Message.update({
                                                                      id: read_message[:id],
                                                                      read: read_message[:read],
                                                                      conversation_id: read_message[:conversation_id]
                                                                    })
      end

      it "will return a message" do
        expect(@updated_message_response[:body]['read']).to be(true)
      end
    end

    context "handles no parameters for updating messages" do
      before do
        @messages = CertifyMessages::Message.update
      end

      it "will return an error message when a bad parameter is sent" do
        expect(@messages[:body]).to eq(CertifyMessages.bad_request[:body])
      end

      it "will return a 422 http status" do
        expect(@messages[:status]).to eq(CertifyMessages.bad_request[:status])
      end
    end

    context "handles bad parameters for updating messages" do
      before do
        @messages = CertifyMessages::Message.update(foo: 'bar')
      end

      it "will return an error message when a bad parameter is sent" do
        expect(@messages[:body]).to eq(CertifyMessages.unprocessable[:body])
      end

      it "will return a 422 http status" do
        expect(@messages[:status]).to eq(CertifyMessages.unprocessable[:status])
      end
    end

    # this will work if the API is disconnected, but I can't figure out how to
    # fake the Excon connection to force it to fail in a test env.
    context "api not found" do
      before do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = false
        # reextend the endpoint to a dummy url
        @bad_message = CertifyMessages::Message.update({body: "foo"})
        @error = CertifyMessages.service_unavailable 'Excon::Error::Socket'
      end

      after do
        CertifyMessages::Resource.clear_connection
        Excon.defaults[:mock] = true
      end

      it "will return a 503" do
        expect(@bad_message[:status]).to eq(@error[:status])
      end
      it "will return an error message" do
        expect(@bad_message[:body]).to eq(@error[:body])
      end
    end
  end
end
