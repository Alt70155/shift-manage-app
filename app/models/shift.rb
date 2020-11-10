class Shift < ApplicationRecord
  belongs_to :user

  def self.create_month_list(date)
    shift_list = where(working_days: date.beginning_of_month..date.end_of_month)
    days_num = Time.days_in_month(date.month, date.year)

    (1..days_num).map do |i|
      day = date.beginning_of_month.strftime('%Y-%m-') + i.to_s
      shift_list.where(working_days: day)
    end
  end
end
