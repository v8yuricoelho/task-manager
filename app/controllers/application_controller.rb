# frozen_string_literal: true

class ApplicationController < ActionController::Base
  SECRET_KEY = ENV['JWT_SECRET'] || 'secret'

  def decode_token
    token = request.headers['Authorization']&.split(' ')&.last
    JWT.decode(token, SECRET_KEY)[0]
  rescue JWT::DecodeError
    nil
  rescue JWT::ExpiredSignature
    nil
  end

  def current_user
    decoded = decode_token
    return nil unless decoded

    @current_user ||= User.find_by(id: decoded['user_id']) if decoded
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end
end
