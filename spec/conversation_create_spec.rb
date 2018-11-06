require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters
RSpec.describe CertifyMessages, type: :feature do
  MessageSpecHelper.mock_conversation_types.each do |type, conv_mock|
    describe "creating a conversation operations from #{type}", :vcr do
      context "when creating new conversations" do
        let(:mock) { MessageSpecHelper.symbolize conv_mock }
        let(:conversation) { CertifyMessages::Conversation.create(mock) }

        it 'will return the correct post response' do
          expect(conversation[:status]).to eq(201)
        end
        # it 'will have the correct body["id"]' do
        #   expect(body["id"]).to eq(mock[:id])
        # end
        # it 'will have the correct body["application_id"]' do
        #   expect(body["application_id"]).to eq(mock[:application_id])
        # end
        # it 'will have the correct body["user_1"]' do
        #   expect(body["user_1"]).to eq(mock[:user_1])
        # end
        # it 'will have the correct body["user_2"]' do
        #   expect(body["user_2"]).to eq(mock[:user_2])
        # end
        # it 'will have the correct body["subject"]' do
        #   expect(body["subject"]).to eq(mock[:subject])
        # end
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
        # it 'will have correct conversation_type' do
        #   expect(body["conversation_type"]).to eq(mock[:conversation_type])
        # end
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

      # context "when api not found" do
      #   let(:conversation) { CertifyMessages::Conversation.create({application_id: 1}) }
      #   let(:error_type) { "Service Unavailable" }
      #
      #   before do
      #     CertifyMessages::Resource.clear_connection
      #     CertifyMessages.configure do |config|
      #       config.api_url = "http://foo.bar/"
      #     end
      #     Excon.defaults[:mock] = false
      #   end
      #
      #   after do
      #     CertifyMessages::Resource.clear_connection
      #     CertifyMessages.configure do |config|
      #       config.api_url = "http://localhost:3001"
      #     end
      #     Excon.defaults[:mock] = false
      #   end
      #
      #   it "will return a 503" do
      #     expect(conversation[:status]).to eq(503)
      #   end
      #
      #   it "will return an error message" do
      #     expect(conversation[:body]).to match(/#{error_type}/)
      #   end
      # end

      context "when creating a conversation with a message: with good parameters" do
        let(:mock) { MessageSpecHelper.symbolize conv_mock }
        let(:response) { CertifyMessages::Conversation.create_with_message(mock) }

        before do
          mock[:body] = Faker::HarryPotter.quote
          # Excon.stub({}, body: mock.to_json, status: 201)
        end

        it "will return 201 for the conversation" do
          expect(response[:conversation][:status]).to eq(201)
        end

        # it "will have the correct subject" do
        #   expect(response[:conversation][:body]["subject"]).to eq(mock[:subject])
        # end
        #
        # it "will return 201 for the message" do
        #   expect(response[:message][:status]).to eq(201)
        # end
        #
        # it "will have the correct body" do
        #   expect(response[:message][:body]["body"]).to eq(mock[:body])
        # end
      end
      context "when creating a conversation with a message: when given bad parameters" do
        let(:mock) { CertifyMessages.unprocessable }
        let(:response) { CertifyMessages::Conversation.create_with_message(mock) }

        # before { Excon.stub({}, body: mock[:body], status: mock[:status]) }

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
#rubocop:enable Style/BracesAroundHashParameters
