class CreateAis < ActiveRecord::Migration[5.0]
  def change
    create_table :ais do |t|
      t.float :min_interval
      t.float :max_interval
      t.float :correct_rate
      t.integer :user_id

      t.timestamps
    end
  end
end
