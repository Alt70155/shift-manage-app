# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :logged_in_admin, only: [:new, :create, :destroy]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  # 以下でdeviseの設定を上書きし、ログイン状態でもサインイン・アップできるようにする
  prepend_before_action :require_no_authentication, only: [:cancel]
  # prepend_before_action :authenticate_scope!, only: [:update, :destroy]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    if by_admin_user?(params)
      self.resource = resource_class.to_adapter.get!(params[:id])
    else
      authenticate_scope!
      super
    end
  end

  # PUT /resource
  # def update
    # self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    # prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # resource_updated = update_resource(resource, account_update_params)
    # yield resource if block_given?
    # if resource_updated
    #   set_flash_message_for_update(resource, prev_unconfirmed_email)
    #   bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

    #   respond_with resource, location: after_update_path_for(resource)
    # else
    #   clean_up_passwords resource
    #   set_minimum_password_length
    #   respond_with resource
    # end
  # end

  # DELETE /resource
  def destroy
    user = User.find(params[:id])

    if user.admin?
      flash[:notice] = '管理者は削除できません。'
    else
      user.destroy
      flash[:notice] = '削除が完了しました。'
    end

    redirect_to root_url
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  def sign_up(resource_name, resource)
    if !current_user_is_admin?
      sign_in(resource_name, resource)
    end
  end

  def by_admin_user?(params)
    params[:id].present? && current_user_is_admin?
  end

  def current_user_is_admin?
    user_signed_in? && current_user.admin?
  end

  def update_resource_without_password(resource, params)
    resource.update_without_password(params)
  end
end
