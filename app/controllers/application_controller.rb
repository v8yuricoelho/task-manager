# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  SECRET_KEY = ENV['JWT_SECRET'] || 'secret'

  def decode_token
    token = request.headers['Authorization']&.split(' ')&.last
    JWT.decode(token, SECRET_KEY)[0]
  rescue JWT::DecodeError
    nil
  rescue JWT::ExpiredSignature
    nil
  end

  def current_user_id
    decoded = decode_token
    return nil unless decoded

    decoded['user_id']
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user_id
  end
end
