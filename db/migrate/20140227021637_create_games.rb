class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :assassin_threshold
      t.string :name
      t.integer :min_difficulty
      t.integer :max_difficulty
      t.integer :mission_count
      t.boolean :started
      t.boolean :completed
      t.integer :time_limit

      t.timestamps
    end
  end
end
