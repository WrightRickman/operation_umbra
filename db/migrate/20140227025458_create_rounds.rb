class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.datetime :round_start
      t.datetime :round_end
      t.integer :game_id
      t.integer :difficulty

      t.timestamps
    end
  end
end
