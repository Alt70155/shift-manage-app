class Shift < ApplicationRecord
  belongs_to :user

  def self.create_month_list(date)
    shift_list = where(working_days: date.beginning_of_month..date.end_of_month)
    days_num = Time.days_in_month(date.month, date.year)

    days_shift_list = (1..days_num).map do |i|
      day = date.beginning_of_month.strftime('%Y-%m-') + i.to_s
      shift_list.where(working_days: day)
    end

    days_shift_list.map do |list|
      list.sort do |a, b|
        a.user.available_time_start <=> b.user.available_time_start
      end
    end
  end
end
