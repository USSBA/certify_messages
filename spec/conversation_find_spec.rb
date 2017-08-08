require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe "CertifyMessages::Conversation.find" do
  describe "find operations" do
    context "for getting conversations" do
      before do
        @mock = MessageSpecHelper.mock_conversations
        Excon.stub({}, body: @mock.to_json, status: 200)
        @conversations = CertifyMessages::Conversation.find({application_id: 1})
        @body = @conversations[:body]
      end

      it "should return a good status code" do
        expect(@conversations[:status]).to eq(200)
      end

      it "should return an array of conversations" do
        expect(@body.length).to be > 0
      end

      it "should contain valid conversation attributes" do
        expect(@body[0]["user_1"]).to be
        expect(@body[0]["application_id"]).to be
        expect(@body[0]["user_2"]).to be
        expect(@body[0]["id"]).to be
        expect(@body[0]["subject"]).to be
      end
    end

    context "handles errors" do
      context "no params" do
        before do
          @conversations = CertifyMessages::Conversation.find
          @body = @conversations[:body]
        end
        it "should return an error message}" do
          expect(@body).to eq(CertifyMessages.bad_request[:body])
        end
        it "should return a 400" do
          expect(@conversations[:status]).to eq(CertifyMessages.bad_request[:status])
        end

      end

      context "bad parameters" do
        before do
          @conversations = CertifyMessages::Conversation.find({foo: 'bar'})
          @body = @conversations[:body]
        end
        it "should return an error message when a bad parameter is sent" do
          expect(@body).to eq(CertifyMessages.unprocessable[:body])
        end

        it "should return a 422 http status" do
          expect(@conversations[:status]).to eq(CertifyMessages.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyMessages::Resource.clear_connection
          Excon.defaults[:mock] = false
          # reextend the endpoint to a dummy url
          @conversations = CertifyMessages::Conversation.find({application_id: 1})
          @error = CertifyMessages.service_unavailable 'Excon::Error::Socket'
        end

        after do
          CertifyMessages::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@conversations[:status]).to eq(@error[:status])
        end

        it "should return an error message" do
          expect(@conversations[:body]).to eq(@error[:body])
        end
      end
    end
  end
end
