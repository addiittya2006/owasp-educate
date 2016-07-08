class ApplicationController < ActionController::Base
  # before_filter :configure_permitted_parameters, if: :devise_controller?
  # before_filter :configure_update_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to articles_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
  end

  # def configure_update_parameters
  #   devise_parameter_sanitizer.for(:update) {|u| u.permit(:name, :email, :password, :password_confirmation, :writer, :admin)}
  # end

end
