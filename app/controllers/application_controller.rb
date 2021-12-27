class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender,  :phone,  :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
    # if resource.is_a?(AdminUser)
    #   stored_location_for(resource) || dashboard_path
    # else
    #   request.env['omniauth.origin'] || stored_location_for(resource) || dashboard_path
    # end
  end

end
