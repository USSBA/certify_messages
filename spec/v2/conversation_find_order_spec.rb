require 'spec_helper'
require 'support/vcr_helper'
require 'support/v2/message_spec_helper'

module V2
  RSpec.describe "V2 CertifyMessages::Conversation", type: :feature do

    before do
      CertifyMessages.configuration.msg_api_version = 2
    end

    describe 'ordering the results of a conversation search', :vcr do
      let(:application_id) { V2::MessageSpecHelper.mock_application_id }

      context 'when requesting conversations with NO specified order' do
        let(:conversations) { CertifyMessages::Conversation.find application_id: application_id }

        it 'will return with the correct status' do
          expect(conversations[:status]).to be 200
        end
      end

      context 'when requesting conversations with ASCENDING order' do
        let(:conversations) { CertifyMessages::Conversation.find(application_id: application_id, order: 'ascending') }

        it 'will return with the correct status' do
          expect(conversations[:status]).to be 200
        end
      end

      context 'when requesting conversations with DESCENDING order' do
        let(:conversations) { CertifyMessages::Conversation.find(application_id: application_id, order: 'descending') }

        it 'will return with the correct status' do
          expect(conversations[:status]).to be 200
        end
      end
    end
  end
end
