require 'spec_helper'
require 'support/vcr_helper'
require 'support/v2/message_spec_helper'

module V2
  RSpec.describe "V2 CertifyMessages::Conversation", type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 2
    end

    let(:user_1) { V2::MessageSpecHelper.mock_user1_uuid }
    let(:user_2) { V2::MessageSpecHelper.mock_user2_uuid }
    let(:application_id) { V2::MessageSpecHelper.mock_application_id }
    let(:convo_subject) { "This is the first subject" }
    let(:conversation_type) { 'application' }
    let(:params) do
      {
        user1_uuid: user_1,
        user2_uuid: user_2,
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
        CertifyMessages::Conversation.archive uuid: conversation[:body]['uuid'], archived: true
      end

      it 'will return with the correct status' do
        expect(archived_convo[:status]).to eq(200)
      end
    end
  end
end
