require "certify_messages/version"
require "certify_messages/configuration"
require "certify_messages/resource"
require "certify_messages/resources/conversation"
require "certify_messages/resources/message"

# the base CertifyMessages module that wraps all conversation and message calls
module CertifyMessages
  extend Configuration
end
