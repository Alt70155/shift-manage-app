class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.date :working_days, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
