require 'spec_helper'
require 'support/vcr_helper'

RSpec.describe CertifyMessages::Conversation, type: :feature do
  let(:user_1) { 1000 }
  let(:user_2) { 2000 }
  let(:application_id) { 10000 }
  let(:convo_subject) { "This is the first subject" }
  let(:conversation_type) { 'application' }
  let(:params) do
    {
      user_1: user_1,
      user_2: user_2,
      application_id: application_id,
      subject: convo_subject,
      conversation_type: conversation_type
    }
  end

  describe 'starting a new conversation', :vcr do
    let(:conversation) do
      CertifyMessages::Conversation.create params
    end

    # before do
    #   CertifyMessages.configure do |config|
    #     config.api_url = "http://localhost:3001"
    #   end
    #   Excon.defaults[:mock] = false
    #   Excon.stubs.clear
    # end

    # it 'will return the created conversation' do
    #   expect(conversation[:body]['subject']).to eq(convo_subject)
    # end
    it 'will return with the correct status' do
      expect(conversation[:status]).to eq(201)
    end

    # restore configuration for exconn stubs
    # after do
    #   CertifyMessages.configure do |config|
    #     config.api_url = "http://foo.bar/"
    #   end
    #   Excon.defaults[:mock] = true
    #   Excon.stub({}, body: { message: 'Fallback stub response' }.to_json, status: 598)
    # end
  end

  describe 'archiving a conversations', :vcr do
    let(:conversation) { CertifyMessages::Conversation.create params }
    let(:archived_convo) do
      CertifyMessages::Conversation.archive conversation_id: conversation[:body]['id'], archived: true
    end

    # before do
    #   CertifyMessages.configure do |config|
    #     config.api_url = "http://localhost:3001"
    #   end
    #   Excon.defaults[:mock] = false
    #   Excon.stubs.clear
    # end

    # it 'will return a list of conversations' do
    #   expect(archived_convo[:body]['archived']).to eq(true)
    # end
    it 'will return with the correct status' do
      expect(archived_convo[:status]).to be(200)
    end

    # restore configuration for exconn stubs
    # after do
    #   CertifyMessages.configure do |config|
    #     config.api_url = "http://foo.bar/"
    #   end
    #   Excon.defaults[:mock] = true
    #   Excon.stub({}, body: { message: 'Fallback stub response' }.to_json, status: 598)
    # end
  end
end
