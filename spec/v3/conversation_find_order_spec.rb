require 'spec_helper'
require 'support/vcr_helper'
require 'support/v3/message_spec_helper'

module V3
  RSpec.describe "V3 CertifyMessages::Conversation", type: :feature do

    before do
      CertifyMessages.configuration.msg_api_version = 3
    end

    describe 'ordering the results of a conversation search', :vcr do
      let(:application_uuid) { V3::MessageSpecHelper.mock_application_uuid }

      context 'when requesting conversations with NO specified order' do
        let(:conversations) { CertifyMessages::Conversation.find application_uuid: application_uuid }

        it 'will return with the correct status' do
          expect(conversations[:status]).to be 200
        end
      end

      context 'when requesting conversations with ASCENDING order' do
        let(:conversations) { CertifyMessages::Conversation.find(application_uuid: application_uuid, order: 'ascending') }

        it 'will return with the correct status' do
          expect(conversations[:status]).to be 200
        end
      end

      context 'when requesting conversations with DESCENDING order' do
        let(:conversations) { CertifyMessages::Conversation.find(application_uuid: application_uuid, order: 'descending') }

        it 'will return with the correct status' do
          expect(conversations[:status]).to be 200
        end
      end
    end
  end
end
