require "spec_helper"
require "./spec/support/v2/message_spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
module V2
  RSpec.describe "V2 CertifyMessages", type: :feature do
    before do
      CertifyMessages.configuration.msg_api_version = 2
    end

    MessageSpecHelper.mock_conversation_types.each do |type, conv_mock|
      describe "creating a conversation operations from #{type}", :vcr do
        context "when creating new conversations" do
          let(:mock) { MessageSpecHelper.symbolize conv_mock }
          let(:conversation) { CertifyMessages::Conversation.create(mock) }

          it 'will return the correct post response' do
            expect(conversation[:status]).to eq(201)
          end
        end

        context "when creating new official conversation" do
          let(:mock) { MessageSpecHelper.symbolize conv_mock }
          let(:conversation) do
            mock[:conversation_type] = 'official'
            CertifyMessages::Conversation.create(mock)
          end

          it "will return correct post response" do
            expect(conversation[:status]).to eq(201)
          end
        end

        context "with empty parameters" do
          let(:conversation) { CertifyMessages::Conversation.create }
          let(:body) { conversation[:body] }

          it "will return an error message when a no parameters are sent" do
            expect(body).to eq(CertifyMessages.bad_request[:body])
          end
          it "will return a 400 http status" do
            expect(conversation[:status]).to eq(CertifyMessages.bad_request[:status])
          end
        end

        context "with bad parameters" do
          let(:conversation) { CertifyMessages::Conversation.create({foo: 'bar'}) }
          let(:body) { conversation[:body] }

          it "will return an error message when a bad parameter is sent" do
            expect(body).to eq(CertifyMessages.unprocessable[:body])
          end

          it "will return a 422 http status" do
            expect(conversation[:status]).to eq(CertifyMessages.unprocessable[:status])
          end
        end

        context "when creating a conversation with a message: with good parameters" do
          let(:mock) { MessageSpecHelper.symbolize conv_mock }
          let(:response) { CertifyMessages::Conversation.create_with_message(mock) }

          before do
            mock[:body] = Faker::HarryPotter.quote
          end

          it "will return 201 for the conversation" do
            expect(response[:conversation][:status]).to eq(201)
          end
        end

        context "when creating a conversation with a message: when given bad parameters" do
          let(:mock) { CertifyMessages.unprocessable }
          let(:response) { CertifyMessages::Conversation.create_with_message(mock) }

          it "will return 422 for the conversation" do
            expect(response[:conversation][:status]).to eq(CertifyMessages.unprocessable[:status])
          end

          it "will have a error status message in the message" do
            expect(response[:conversation][:body]).to eq(mock[:body])
          end

          it "will return 422 for the message" do
            expect(response[:message][:status]).to eq(422)
          end

          it "will have an error message" do
            expect(response[:message][:body]).to eq("An error occurred creating the conversation")
          end
        end
      end
    end
  end
end
#rubocop:enable Style/BracesAroundHashParameters
