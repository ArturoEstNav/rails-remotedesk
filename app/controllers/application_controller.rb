class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # protected

  # def after_sign_in_path_for(current_user)
  #   # return the path based on resource
  #    edit_user_registration
  # end

  # def after_sign_out_path_for(scope)
  #   # return the path based on scope
  # end
end
