class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[profile]

  def index
    @request_list = current_user.requests.all if user_signed_in?
  end

  def profile
  end
end
