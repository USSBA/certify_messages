require 'logger' unless defined?(logger)

module CertifyMessages
  # simple extension of the Ruby Logger that can accept the log severity level from user config
  class DefaultLogger < Resource
    attr_reader :logger

    # create the new logger with the default debug or accepting a log_level parameter
    def initialize(log_level = 'debug')
      @logger = Logger.new(STDOUT, level: log_level)
    end
  end
end
