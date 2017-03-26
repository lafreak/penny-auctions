class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :address])
  end

  def user_not_authorized
    flash[:danger] = "You are not authorized to perform this action."
    redirect_to (request.referrer || root_path)
  end
end
