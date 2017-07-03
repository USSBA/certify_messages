# error handlers
module CertifyMessages
  # Custom error class for rescuing from all Messages API errors
  class Error < StandardError; end

  # Raised when Messsages API returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Messsages API returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Messsages API returns the HTTP status code 503
  class ServiceUnavailable < Error; end

  def self.service_unavailable(error)
    {body: "There was a problem connecting to the messages API. Type: #{error}", status: 503}
  end

  # Raised when Messsages API returns the HTTP status code 400
  def self.bad_request
    {body: "No parameters submitted", status: 400}
  end

  def self.unprocessable
    {body: "Invalid parameters submitted", status: 422}
  end
end
