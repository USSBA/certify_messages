require "spec_helper"

RSpec.describe CertifyMessages do
  context "Creating the default Logger" do
    let(:logger) { CertifyMessages::DefaultLogger.new.logger }

    it "uses the default debug log level when none is specified" do
      expect(logger.level).to eq(0)
    end
  end

  # handles all the standard log levels
  %w[debug info warn error fatal unknown].each_with_index do |level, i|
    context "Creating the default Logger with '#{level}' log level specified" do
      let(:logger) { (CertifyMessages::DefaultLogger.new level).logger }

      it "uses the default log level" do
        expect(logger.level).to eq(i)
      end
    end
  end

  context "returns an error if an invalid log level is provided" do
    it "raises error" do
      expect { CertifyMessages::DefaultLogger.new "foo" }.to raise_error(ArgumentError)
    end
  end
end
