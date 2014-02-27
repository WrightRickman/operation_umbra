class CreatePlayerMissions < ActiveRecord::Migration
  def change
    create_table :player_missions do |t|
      t.integer :mission_id
      t.integer :game_id
      t.integer :handler_id
      t.integer :agent_id
      t.integer :round_id
      t.integer :target_id
      t.datetime :completed, :default => false

      t.timestamps
    end
  end
end
