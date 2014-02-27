class CreateGamePlayers < ActiveRecord::Migration
  def change
    create_table :game_players do |t|
      t.integer :user_id
      t.integer :game_id
      t.boolean :alive, :default => true

      t.timestamps
    end
  end
end
