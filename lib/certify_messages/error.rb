module CertifyMessages
  # Custom error class for rescuing from all Messages API errors
  class Error < StandardError; end

  # Raised when Messsages API returns the HTTP status code 400
  # class BadRequest < Error;
  def self.BadRequest
    {body: "No parameters submitted", status: 400}
  end

  def self.Unprocessable
    {body: "Invalid parameters submitted", status: 422}
  end


  # Raised when Messsages API returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Messsages API returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Messsages API returns the HTTP status code 503
  class ServiceUnavailable < Error; end
end
