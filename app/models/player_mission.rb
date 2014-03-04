class PlayerMission < ActiveRecord::Base
  
	belongs_to :user
	belongs_to :round
	belongs_to :mission

  # returns the handler of the mission
  def handler
    User.find(self.handler_id)
  end

  # method for sending the player their mission... still coming
  def brief
    puts "I am briefing #{self.user.user_name}. This player's agent is #{self.handler.user_name}, and their mission is to #{self.mission.description}"
  end

  # method called when a handler accepts a mission
  def debrief
    # set the mission's success to true and save
    self.success = true
    self.save!
    self.reload
    # increase points for agent
    current_user_points = self.user.game_players.last.points
    self.user.game_players.last.points = current_user_points + 2
    self.user.game_players.last.save!
    # increase the handler's points
    current_handler_points = self.handler.game_players.last.points
    self.handler.game_players.last.points = current_handler_points + 1
    self.handler.game_players.last.save!
    # check to see if the round was a deathmatch
    if self.round.users.length == 2
      # if the round was a deathmatch, the player won!
      self.round.game.end_game(self.user)
    # otherwise, proceed as usual
    else
      self.round.check_missions_status
    end
  end

  # method called when a handler fails a mission
  def failure
    # set the mission's success to false and save
    self.success = false
    self.save!
    self.reload
    # check to see if the round is complete
    self.round.check_missions_status
  end

end
