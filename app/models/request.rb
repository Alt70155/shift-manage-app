class Request < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :date, presence: true, uniqueness: { scope: :user_id } # 複合ユニーク制約
  validates :possible, presence: true
end
