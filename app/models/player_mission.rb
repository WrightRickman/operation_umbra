class PlayerMission < ActiveRecord::Base
	belongs_to :users
	belongs_to :rounds
	belongs_to :missions
end
