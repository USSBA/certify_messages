module CertifyMessages
  module VERSION
    MAJOR = 1
    MINOR = 4
    PATCH = 0
    PRE_RELEASE = "".freeze # e.g., "-beta"

    STRING = ([MAJOR, MINOR, PATCH].join('.') + PRE_RELEASE).freeze
  end
end
