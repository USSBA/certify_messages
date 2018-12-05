require 'spec_helper'
require 'support/vcr_helper'

module V1
  RSpec.describe CertifyMessages::Conversation, type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 1
    end

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
      let(:conversation) { CertifyMessages::Conversation.create params }

      it 'will return with the correct status' do
        expect(conversation[:status]).to eq(201)
      end
    end

    describe 'archiving a conversations', :vcr do
      let(:conversation) { CertifyMessages::Conversation.create params }
      let(:archived_convo) do
        CertifyMessages::Conversation.archive id: conversation[:body]['id'], archived: true
      end

      it 'will return with the correct status' do
        expect(archived_convo[:status]).to eq(200)
      end
    end
  end
end
