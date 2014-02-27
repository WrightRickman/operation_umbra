class Mission < ActiveRecord::Base
	has_many :player_missions
	has_many :games, through: :player_missions
  has_many :users, through: :player_missions
end
