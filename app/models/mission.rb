class Mission < ActiveRecord::Base
	has_many :player_missions
	has_many :games, :through => :users
end
