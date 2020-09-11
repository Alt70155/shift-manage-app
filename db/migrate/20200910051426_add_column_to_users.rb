class AddColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :available_time_start, :time
    add_column :users, :available_time_end,   :time
    add_column :users, :available_days,       :date
  end
end
