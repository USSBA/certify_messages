require "spec_helper"

RSpec.describe CertifyMessages do
  it "has a version number" do
    expect(CertifyMessages::VERSION).not_to be nil
  end

  it "will have an endpoint url" do
    expect(described_class.configuration.api_url).to eq('http://localhost:3001')
  end

  # rubocop:disable RSpec/ExpectActual
  it "will specify the message API version" do
    expect(1..3).to cover(described_class.configuration.msg_api_version)
  end
  # rubocop:enable RSpec/ExpectActual

  it "will have a different excon_timeout than default" do
    expect(described_class.configuration.excon_timeout).to eq(6)
  end

  it "will have a Conversation class" do
    expect(CertifyMessages::Conversation.new).to be
  end
end
