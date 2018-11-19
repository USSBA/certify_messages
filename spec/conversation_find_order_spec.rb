require 'spec_helper'
require 'support/vcr_helper'

RSpec.describe CertifyMessages::Conversation, type: :feature do
  describe 'ordering the results of a conversation search in v1', :vcr do
    let(:application_id) { '4' }

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

  describe 'ordering the results of a conversation search in v3', :vcr do
    before do
      CertifyMessages.configuration.msg_api_version = 3
    end
    let(:application_uuid) { '132ae1b3-734f-4313-a418-18667876fe56' }

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

    after do
      CertifyMessages.configuration.msg_api_version = 1
    end
  end
end
