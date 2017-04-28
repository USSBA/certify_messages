require "spec_helper"

RSpec.describe CertifyMessages do
  it "has a version number" do
    expect(CertifyMessages::VERSION).not_to be nil
  end

  it "should have an endpoint url" do
    expect(CertifyMessages.endpoint).to eq('http://localhost:3001/')
  end

  it "should have a Conversation class" do
    expect(CertifyMessages::Conversation.new).to be
  end

end
