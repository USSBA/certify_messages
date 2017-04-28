require "spec_helper"

RSpec.describe CertifyMessages::Conversation do

  context "for getting conversations" do
    before do
      @conversation = CertifyMessages::Conversation.find(1)
    end

    it "should return a single conversation" do
      expect(@conversation.analyst_id).to exist
      expect(@conversation.application_id).to exist
      expect(@conversation.contributor_id).to exist
      expect(@conversation.id).to exist
      expect(@conversation.subject).to exist
    end
  end
end
