class PlayerMission < ActiveRecord::Base
	belongs_to :user
	belongs_to :round
	belongs_to :mission
end
