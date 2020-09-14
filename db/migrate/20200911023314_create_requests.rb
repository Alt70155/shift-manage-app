class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true, null: false
      t.date    :date,     null: false
      t.boolean :possible, null: false

      t.timestamps
    end

    # 複合ユニーク制約
    add_index :requests, %i[user_id date], unique: true
  end
end
