module CertifyMessages
  # conversation class that handles getting and posting new conversations
  class Conversation < Resource
    attr_accessor :status

    def initialize
      @status = "I'm alive"
    end
  end
end
