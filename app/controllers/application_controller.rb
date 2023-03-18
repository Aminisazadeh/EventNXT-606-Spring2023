# class ApplicationController < ActionController::Base
#   # Prevent CSRF attacks by raising an exception.
#   # For APIs, you may want to use :null_session instead.
#   #before_action :authenticate_user!, :except => []
#   # protect_from_forgery prepend: true, with: :exception
#   helper_method :current_user
#   protected

#   def render_not_found
#     render file: Rails.root.join('public', '404.html'), status: 404;
#   end

#   def current_user
#     @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id]) if doorkeeper_token
#   end
# end







class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end