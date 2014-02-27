class Round < ActiveRecord::Base
	belongs_to :game
	has_many :player_missions
end
