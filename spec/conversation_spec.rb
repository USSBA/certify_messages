require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
RSpec.describe CertifyMessages::Conversation do

  context "for getting conversations" do
    before do
      @mock = MessageSpecHelper.mock_conversations
      Excon.stub({}, body: @mock.to_json, status: 200)
      @conversations = CertifyMessages::Conversation.find({application_id: 1})
    end

    it "should return an array of conversations" do
      expect(@conversations.length).to be > 0
      expect(@conversations[0]["analyst_id"]).to be
      expect(@conversations[0]["application_id"]).to be
      expect(@conversations[0]["contributor_id"]).to be
      expect(@conversations[0]["id"]).to be
      expect(@conversations[0]["subject"]).to be
    end
  end

  context "handles bad parameters" do
    before do
      @conversations = CertifyMessages::Conversation.find({foo: 'bar'})
    end
    it "should return an error message when a bad parameter is sent" do
      expect(@conversations).to eq("Invalid parameters submitted")
    end
  end
end
