class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # deviseにパラメータを追加するためのメソッド
  def configure_permitted_parameters
    added_attrs = %i[first_name last_name available_time_start available_time_end available_days]
    devise_parameter_sanitizer.permit(:sign_up,        keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
