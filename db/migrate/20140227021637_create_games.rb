class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :assassin_threshold, :default => 10
      t.string :name, :default => 'Umbra Agency'
      t.integer :min_difficulty, :default => 1
      t.integer :max_difficulty, :default => 2
      t.integer :mission_count, :default => 0
      t.boolean :started, :default => false
      t.boolean :completed
      t.integer :time_limit
      t.integer :creator_id

      t.timestamps
    end
  end
end
