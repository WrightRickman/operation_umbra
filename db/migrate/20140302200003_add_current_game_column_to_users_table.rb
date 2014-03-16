class AddCurrentGameColumnToUsersTable < ActiveRecord::Migration
  def change
  	add_column :users, :current_game_id, :integer 
  end
end
