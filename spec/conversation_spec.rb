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
  let(:params_v3) do
    {
        user1_uuid: "16028520-03c5-4bcc-9e90-d826613a4166",
        user2_uuid: "fab8c5a8-e746-47d6-aef2-2f52c185317e",
        application_uuid: "132ae1b3-734f-4313-a418-18667876fe56",
        subject: convo_subject,
        conversation_type: conversation_type
    }
  end

  describe 'starting a new conversation in v1', :vcr do
    let(:conversation) do
      CertifyMessages::Conversation.create params
    end

    it 'will return with the correct status' do
      expect(conversation[:status]).to eq(201)
    end
  end

  describe 'archiving a conversation in v1', vcr: false do
    let(:conversation) { CertifyMessages::Conversation.create params }
    let(:archived_convo) do
      CertifyMessages::Conversation.archive conversation_id: conversation[:body]['id'], archived: true
    end

    it 'will return with the correct status' do
      expect(archived_convo[:status]).to be(200)
    end
  end
end
