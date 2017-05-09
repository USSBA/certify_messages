require "spec_helper"

RSpec.describe CertifyMessages do
  it "has a version number" do
    expect(CertifyMessages::VERSION).not_to be nil
  end

  it "should have an endpoint url" do
    expect(CertifyMessages.configuration.api_url).to eq('http://foo.bar/')
  end

  it "should specify the message API version" do
    expect(CertifyMessages.configuration.hubzone_api_version).to eq(1)
  end

  it "should have a Conversation class" do
    expect(CertifyMessages::Conversation.new).to be
  end

end
