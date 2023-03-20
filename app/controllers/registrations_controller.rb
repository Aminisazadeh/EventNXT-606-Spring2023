# ================================================= %>
# following section is commented by "AMIN ISAZADEH" %>



# class RegistrationsController < Devise::RegistrationsController
#   before_action :configure_permitted_parameters, if: :devise_controller?
#   respond_to :json

#   protected

#   def sign_up(resource_name, resource)
#   end

#   def configure_permitted_parameters
#     devise_parameter_sanitizer.permit(:sign_up) do |user_params|
#       user_params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
#     end
#   end

#   private

#   def respond_with(resource, _opts={})
#     render json: resource
#     if resource.id.nil?
#       head :unprocessable_entity
#     else
#       head :ok
#     end
#   end

# end



# above section is commented by "AMIN ISAZADEH" %>
# ================================================= %>








# ================================================= %>
# following section is added by "AMIN ISAZADEH" %>

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    #'/an/example/path' # Or :prefix_to_your_route
    events_index_path
  end
  
  def after_sign_in_path_for(resource)
    events_index_path
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
end

# above section is added by "AMIN ISAZADEH" %>
# ================================================= %>