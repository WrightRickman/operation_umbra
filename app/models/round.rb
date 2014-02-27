class Round < ActiveRecord::Base
	belongs_to :games
	has_many :player_missions
end
