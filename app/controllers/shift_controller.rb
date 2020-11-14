class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[index profile]
  before_action :logged_in_admin, only: %i[users]

  def index
    @request_list = current_user.requests.all.order(:date)
    # 今月のシフト・来月のシフトの両方を日にちによって表示する/しないを判定する必要あり
    # 今月のシフト
    @this_month = Date.today
    @this_month_shift_list = Shift.create_month_list(@this_month)
  end

  def next_month_shift
    # 来月のシフト
    @next_month = Date.today.next_month
    @next_month_shift_list = Shift.create_month_list(@next_month)
  end

  def profile
  end

  def users
    @user_list = User.all
  end

  private

    def create_shift_list(date)
      shift_list = Shift.where(working_days: date.beginning_of_month..date.end_of_month)

      grouped_shift_list = []
      days_num = Time.days_in_month(date.month, date.year)
      days_num.times do |i|
        day = date.beginning_of_month.strftime('%Y-%m-') + (i + 1).to_s
        grouped_shift_list.append(shift_list.where(working_days: day))
      end
    end
end
