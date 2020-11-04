class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[index profile]
  before_action :logged_in_admin, only: %i[users]

  def index
    @request_list = current_user.requests.all.order(:date)
    # 今月のシフト・来月のシフトの両方を日にちによって表示する/しないを判定する必要あり
    @next_month = Date.today.next_month
    next_month_shift_list = Shift.where(working_days: @next_month.beginning_of_month..@next_month.end_of_month)

    @grouped_next_month_shift_list = []
    days_in_next_month = Time.days_in_month(@next_month.month, @next_month.year)
    days_in_next_month.times do |i|
      day = @next_month.beginning_of_month.strftime('%Y-%m-') + (i + 1).to_s
      @grouped_next_month_shift_list.append(next_month_shift_list.where(working_days: day))
    end

  end

  def profile
  end

  def users
    @user_list = User.all
  end
end
