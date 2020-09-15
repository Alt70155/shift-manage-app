class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :emp_per_day_number,  null: false
      t.time    :business_start_time, null: false
      t.time    :business_end_time,   null: false
      t.integer :regular_holiday,     null: false

      t.timestamps
    end
    # 複合ユニーク制約
    add_index :stores, %i[id user_id], unique: true
  end
end
