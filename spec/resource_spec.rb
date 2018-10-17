require "spec_helper"

#rubocop:disable Metrics/BlockLength
RSpec.describe CertifyMessages do
  describe "testing basic resource params" do
    let!(:timeout) { 100 }
    let!(:url) { described_class.configuration.api_url }
    let(:connection) { described_class::ApiConnection.new url, timeout }
    let(:params) { connection.conn.params }

    it "has correct connect_timeout" do
      expect(params[:connect_timeout]).to eq(timeout)
    end

    it "has correct write_timeout" do
      expect(params[:write_timeout]).to eq(timeout)
    end

    it "has correct read_timeout" do
      expect(params[:read_timeout]).to eq(timeout)
    end
  end

  describe "handles writing logs and errors" do
    let(:error) { Excon::Error.new }
    let(:backtrace) { ["bad thing 1", "bad thing 2"] }
    let(:error_response) { CertifyMessages::Resource.handle_excon_error error }

    before { error.set_backtrace backtrace }

    it "raises an error if a bad log level is specified" do
      expect { CertifyMessages::Resource.logger.foo("bad error") }.to raise_error(NoMethodError)
    end

    it "logs the message for a valid log level" do
      expect { CertifyMessages::Resource.logger.error("bad error") }.not_to raise_error
    end

    it "return an error message" do
      expect(error_response[:body]).to match("Excon::Error")
    end

    it "return an error code" do
      expect(error_response[:status]).to eq(503)
    end
  end
end
#rubocop:enable Metrics/BlockLength
