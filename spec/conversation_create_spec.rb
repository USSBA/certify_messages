require "spec_helper"

#rubocop:disable Style/BracesAroundHashParameters, Metrics/BlockLength
RSpec.describe "CertifyMessages::Conversation.create" do
  describe "create operations" do
    context "for creating new conversations" do
      before do
        @mock = MessageSpecHelper.mock_conversation
        Excon.stub({}, body: @mock.to_json, status: 201)
        @conversation = CertifyMessages::Conversation.create(@mock)
        @body = @conversation[:body]
      end

      it "should return the correct post response" do
        expect(@conversation[:status]).to eq(201)
      end

      it "should return the new conversation object" do
        expect(@body["id"]).to eq(@mock[:id])
        expect(@body["application_id"]).to eq(@mock[:application_id])
        expect(@body["user_1"]).to eq(@mock[:user_1])
        expect(@body["user_2"]).to eq(@mock[:user_2])
        expect(@body["subject"]).to eq(@mock[:subject])
      end
    end

    context "handles errors" do

      context "empty parameters" do
        before do
          @conversation = CertifyMessages::Conversation.create({})
          @body = @conversation[:body]
        end
        it "should return an error message when a no parameters are sent" do
          expect(@body).to eq(CertifyMessages.bad_request[:body])
        end

        it "should return a 400 http status" do
          expect(@conversation[:status]).to eq(CertifyMessages.bad_request[:status])
        end
      end

      context "bad parameters" do
        before do
          @conversation = CertifyMessages::Conversation.create({foo: 'bar'})
          @body = @conversation[:body]
        end
        it "should return an error message when a bad parameter is sent" do
          expect(@body).to eq(CertifyMessages.unprocessable[:body])
        end

        it "should return a 422 http status" do
          expect(@conversation[:status]).to eq(CertifyMessages.unprocessable[:status])
        end
      end

      # this will work if the API is disconnected, but I can't figure out how to
      # fake the Excon connection to force it to fail in a test env.
      context "api not found" do
        before do
          CertifyMessages::Resource.clear_connection
          Excon.defaults[:mock] = false
          @conversation = CertifyMessages::Conversation.create({application_id: 1})
        end

        after do
          CertifyMessages::Resource.clear_connection
          Excon.defaults[:mock] = true
        end

        it "should return a 503" do
          expect(@conversation[:status]).to eq(503)
        end
      end
    end

    context "should create a conversation with a new message" do
      context "when given good parameters" do
        before do
          @mock = MessageSpecHelper.mock_conversation
          @mock[:body] = Faker::HarryPotter.quote
          Excon.stub({}, body: @mock.to_json, status: 201)
          @response = CertifyMessages::Conversation.create_with_message(@mock)
        end

        context "the newly created conversation" do
          it "should return 201" do
            expect(@response[:conversation][:status]).to eq(201)
          end

          it "should have the correct subject" do
            expect(@response[:conversation][:body][:subject]).to eq(@mock["subject"])
          end
        end

        context "the newly created message" do
          it "should return 201" do
            expect(@response[:message][:status]).to eq(201)
          end

          it "should have the correct body" do
            expect(@response[:message][:body]["body"]).to eq(@mock[:body])
          end
        end
      end

      context "when given bad parameters" do
        before do
          @mock = CertifyMessages.unprocessable
          Excon.stub({}, body: @mock[:body], status: @mock[:status])
          @response = CertifyMessages::Conversation.create_with_message(@mock)
        end

        context "the newly created conversation" do
          it "should return 422" do
            expect(@response[:conversation][:status]).to eq(CertifyMessages.unprocessable[:status])
          end

          it "should have a error status message in the message" do
            expect(@response[:conversation][:body]).to eq(@mock[:body])
          end
        end

        context "the newly created message" do
          it "should return 422" do
            expect(@response[:message][:status]).to eq(422)
          end

          it "should have an error message" do
            expect(@response[:message][:body]).to eq("An error occurred creating the conversation")
          end
        end
      end
    end
  end
end
