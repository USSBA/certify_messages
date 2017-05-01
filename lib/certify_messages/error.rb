module CertifyMessages
  # Custom error class for rescuing from all Messages API errors
  class Error < StandardError; end

  # Raised when Messsages API returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Messsages API returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Messsages API returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Messsages API returns the HTTP status code 503
  class ServiceUnavailable < Error; end
end
