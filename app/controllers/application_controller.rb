class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :configure_permitted_parameters, if: :devise_controller?

  # protected

  # def after_sign_in_path_for(current_user)
  #   # return the path based on resource
  #    edit_user_registration
  # end

  # def after_sign_out_path_for(scope)
  #   # return the path based on scope
  # end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end

def default_url_options
  { host: ENV["DOMAIN"] || "localhost:3000" }
end
