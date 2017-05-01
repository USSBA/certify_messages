require "certify_messages/configuration"
require "certify_messages/error"
require "certify_messages/resource"
require "certify_messages/version"
require "certify_messages/resources/conversation"

# the base CertifyMessages module that wraps all conversation and message calls
module CertifyMessages
  extend Configuration
end
