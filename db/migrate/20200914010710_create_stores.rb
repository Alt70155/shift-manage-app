class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.integer :emp_per_day_number,  null: false
      t.time    :business_start_time, null: false
      t.time    :business_end_time,   null: false
      t.integer :regular_holiday,     null: false

      t.timestamps
    end
  end
end
