class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[index profile]
  before_action :logged_in_admin, only: %i[users]

  def index
    @request_list = current_user.requests.all.order(:date)
    # 今月のシフト・来月のシフトの両方を日にちによって表示する/しないを判定する必要あり
    next_month = Date.today.next_month
    @shift_list = Shift.where(working_days: next_month.beginning_of_month..next_month.end_of_month)
    @user_list = User.all
  end

  def profile
  end

  def users
    @user_list = User.all
  end
end
