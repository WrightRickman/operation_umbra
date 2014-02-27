class GamePlayers < ActiveRecord::Base
	has_many :game_players
	has_many :rounds
	has_many :missions, :through => :users 
end
