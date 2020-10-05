class ShiftController < ApplicationController
  before_action :logged_in_user, only: %i[index profile]
  before_action :logged_in_admin, only: %i[users]

  def index
    @request_list = current_user.requests.all.order(:date)
    @user_list = User.all

    # 来月の日数を取得
    now = Time.current
    next_date = now.next_month
    days_in_next_month = Time.days_in_month(next_date.month, next_date.year)
    # 勤務可能時間が正社員レベルの人とバイトレベルの人を分ける
    
  end

  def profile
  end

  def users
    @user_list = User.all
  end
end
