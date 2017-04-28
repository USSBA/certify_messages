module CertifyMessages
  # configuration module
  module Configuration
    # main api endpoint
    # TODO: set to env
    def endpoint
      "http://localhost:3001/"
    end

    # default conversations path
    def conversations_path
      "conversations"
    end
  end
end
