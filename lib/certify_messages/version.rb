module CertifyMessages
  module VERSION
    MAJOR = 2
    MINOR = 1
    PATCH = 0
    PRE_RELEASE = "".freeze # e.g., "-beta"

    STRING = ([MAJOR, MINOR, PATCH].join('.') + PRE_RELEASE).freeze
  end
end
