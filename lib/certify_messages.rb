require "byebug"
require "certify_messages/configuration"
require "certify_messages/error"
require "certify_messages/resource"
require "certify_messages/version"
require "certify_messages/resources/default_logger"
require "certify_messages/resources/conversation"
require "certify_messages/resources/message"

# the base CertifyMessages module that wraps all conversation and message calls
module CertifyMessages
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
