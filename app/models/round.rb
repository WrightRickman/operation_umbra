class Round < ActiveRecord::Base
	belongs_to :game
	has_many :player_missions
  has_many :users, through: :player_missions
end
