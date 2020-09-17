class Store < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :emp_per_day_number,  presence: true, numericality: { greater_than: 0 }
  validates :business_start_time, presence: true
  validates :business_end_time,   presence: true
  validates :regular_holiday,     presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to:    7
  }
end
