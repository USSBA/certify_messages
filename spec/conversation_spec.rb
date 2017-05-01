require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe CertifyMessages::Conversation do
  describe "find operations" do
    # a hack, set the endpoint at a config level
    before do
      def CertifyMessages.endpoint
        super
        'http://foo.bar'
      end
    end

    context "for getting conversations" do
      before do
        @mock = MessageSpecHelper.mock_conversations
        Excon.stub({}, body: @mock.to_json, status: 200)
        @conversations = CertifyMessages::Conversation.find({application_id: 1})
        @body = @conversations.body
      end

      it "should return a good status code" do
        expect(@conversations.status).to eq(200)
      end

      it "should return an array of conversations" do
        expect(@body.length).to be > 0
      end

      it "should contain valid conversation attributes" do
        expect(@body[0]["analyst_id"]).to be
        expect(@body[0]["application_id"]).to be
        expect(@body[0]["contributor_id"]).to be
        expect(@body[0]["id"]).to be
        expect(@body[0]["subject"]).to be
      end
    end

    context "handles errors" do
      before do
        @conversations = CertifyMessages::Conversation.find({foo: 'bar'})
        @body = @conversations[:body]
      end

      context "bad parameters" do
        it "should return an error message when a bad parameter is sent" do
          expect(@body).to eq("Invalid parameters submitted")
        end

        it "should return a 400 http status" do
          expect(@conversations[:status]).to eq(400)
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          Excon.defaults[:mock] = false
          # reextend the endpoint to a dummy url

          @conversations = CertifyMessages::Conversation.find({application_id: 1})
        end

        after do
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@conversations[:status]).to eq(503)
        end
      end

    end
  end

  describe "create operations" do
    context "for creating new conversations" do
      before do
        @mock = MessageSpecHelper.mock_conversation
        Excon.stub({}, body: @mock.to_json, status: 201)
        @conversation = CertifyMessages::Conversation.create(@mock)
        @body = @conversation.body
      end

      it "should return the correct post response" do
        expect(@conversation.status).to eq(201)
      end

      it "should return the new conversation object" do
        expect(@body["id"]).to eq(@mock[:id])
        expect(@body["application_id"]).to eq(@mock[:application_id])
        expect(@body["analyst_id"]).to eq(@mock[:analyst_id])
        expect(@body["contributor_id"]).to eq(@mock[:contributor_id])
        expect(@body["subject"]).to eq(@mock[:subject])
      end
    end

    context "handles errors" do
      before do
        @conversation = CertifyMessages::Conversation.create({foo: 'bar'})
        @body = @conversation[:body]
      end

      context "bad parameters" do
        it "should return an error message when a bad parameter is sent" do
          expect(@body).to eq("Invalid parameters submitted")
        end

        it "should return a 400 http status" do
          expect(@conversation[:status]).to eq(400)
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          Excon.defaults[:mock] = false
          @conversation = CertifyMessages::Conversation.create({application_id: 1})
        end

        after do
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@conversation[:status]).to eq(503)
        end
      end

    end
  end
end
