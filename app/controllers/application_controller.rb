class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # deviseにパラメータを追加するためのメソッド
  def configure_permitted_parameters
    added_attrs = %i[first_name last_name available_time_start available_time_end available_days]
    devise_parameter_sanitizer.permit(:sign_up,        keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

    def logged_in_user
      unless user_signed_in?
        flash[:danger] = 'ログインが必要なページです。'
        redirect_to '/users/sign_in'
      end
    end

    def logged_in_admin
      unless user_signed_in? && current_user.admin?
        flash[:danger] = '管理者のみアクセスできるページです。'
        redirect_to root_url
      end
    end
end
