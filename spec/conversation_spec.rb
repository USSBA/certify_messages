require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe CertifyMessages::Conversation do

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

    context "api not found" do
      before do
        Excon.defaults[:mock] = false
        @conversations = CertifyMessages::Conversation.find({application_id: 1})
      end

      it "should return the 404" do
        expect(@conversations[:status]).to eq(503)
      end

    end
  end
end
