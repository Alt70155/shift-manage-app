class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[index profile]
  before_action :logged_in_admin, only: %i[users]

  def index
    @request_list = current_user.requests.all.order(:date)
    @user_list = User.all
  end

  def profile
  end

  def users
    @user_list = User.all
  end
end
