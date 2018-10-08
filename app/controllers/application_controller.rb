class ApplicationController < ActionController::API
  require 'json_web_token'
  include ActionController::MimeResponds

  protected
  # Validates the token and user and sets the @current_user scope
  def authenticate_request
    if !payload || !JsonWebToken.valid_payload(payload.first)
      return invalid_authentication
    end
  end

  # Returns 401 response. To handle malformed / invalid requests.
  def invalid_authentication
    render json: {error: 'Unauthorized request'}, status: :unauthorized
  end

  private
  # Deconstructs the Authorization header and decodes the JWT token.
  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  rescue
    nil
  end

end
