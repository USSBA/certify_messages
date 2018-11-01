require 'spec_helper'
require 'support/vcr_helper'

RSpec.describe CertifyMessages::Conversation, type: :feature do
  describe 'ordering the results of a conversation search', :vcr do
    let(:application_id) { '4' }

    before do
      CertifyMessages.configure do |config|
        config.api_url = "http://localhost:3001"
      end
      Excon.defaults[:mock] = false
      Excon.stubs.clear
    end

    # restore configuration for exconn stubs
    after do
      CertifyMessages.configure do |config|
        config.api_url = "http://foo.bar/"
      end
      Excon.defaults[:mock] = true
      Excon.stub({}, body: { message: 'Fallback stub response' }.to_json, status: 598)
    end

    context 'when requesting conversations with NO specified order' do
      let(:conversations) do
        CertifyMessages::Conversation.find application_id: application_id
      end

      xit 'will return with the correct status' do
        pending('waiting on the new gem testing pattern')
      end
    end

    context 'when requesting conversations with ASCENDING order' do
      let(:conversations) do
        CertifyMessages::Conversation.find(application_id: application_id, order: 'ascending')
      end

      xit 'will return a list of conversations' do
        expect(conversations[:body].length).to eq(2)
      end
      xit 'will return with the correct status' do
        expect(conversations[:status]).to be(200)
      end
      xit 'will return the newest converstation first' do
        expect(conversations[:body].first['id']).to be 9
      end
    end

    context 'when requesting conversations with DESCENDING order' do
      let(:conversations) do
        CertifyMessages::Conversation.find(application_id: application_id, order: 'descending')
      end

      xit 'will return a list of conversations' do
        expect(conversations[:body].length).to eq(2)
      end
      xit 'will return with the correct status' do
        expect(conversations[:status]).to be(200)
      end
      xit 'will return the oldest converstation first' do
        expect(conversations[:body].first['id']).to be 4
      end
    end
  end
end
