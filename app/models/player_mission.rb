class PlayerMission < ActiveRecord::Base
  attr_accessor :user, :round, :mission
	belongs_to :user
	belongs_to :round
	belongs_to :mission

  # returns the handler of the mission
  def handler
    User.find(self.handler_id)
  end

  # method for sending the player their mission... still coming
  def brief
    # puts "I am briefing #{self.user.user_name}. This player's agent is #{self.handler.user_name}, and their mission is to #{self.mission.description}"
  end

  # method called when a handler accepts a mission
  def debrief
    # set the mission's completed time to current time
    self.completed = Time.now
    self.save!
    self.reload
    # check to see if the round was a deathmatch
    if self.round.agents.length == 2
      # if the round was a deathmatch, the player won!
      self.round.game.end_game(self.user)
    # otherwise, proceed as usual
    else
      self.round.check_missions_status
    end
  end

end
