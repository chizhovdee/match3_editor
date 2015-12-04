class ApplicationController < ActionController::Base
    USERS = [
    1646690531, # Dmitri Chizhov
    1461614218, # Aleksey Dmitriev
    508157615,  # Svetlana Tarasova
    4043115997  # Olga Velina
  ]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :http_authentication

  protected

  def http_authentication
    authenticate_or_request_with_http_basic do |login, password|
      USERS.include?(Zlib.crc32("#{ login }:#{ password }"))
    end
  end
end
