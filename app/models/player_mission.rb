class PlayerMission < ActiveRecord::Base
  
  belongs_to :game_player
	belongs_to :round
	belongs_to :mission

  # returns the handler of the mission
  def handler
    User.find(self.handler_id)
  end

  # method for sending the player their mission... still coming
  def brief
    # puts "I am briefing #{self.user.user_name}. This player's agent is #{self.handler.user_name}, and their mission is to #{self.mission.description}"
    # Check to see if the mission is an assassination or not
    puts "I am briefing #{self.game_player.user_name}. This player's agent is #{self.handler.user_name}, and their mission is to #{self.mission.description}"
  end

  # method called when a handler accepts a mission
  def debrief
    # set the mission's success to true and save
    self.success = true
    self.save!
    self.reload
    # increase points for agent
    user_player = self.game_player
    user_player.points = user_player.points + 2
    user_player.save!
    # increase the handler's points
    binding.pry
    handler_player = self.handler.game_players.last
    handler_player.points = handler_player.points + 1
    handler_player.save!
    # Increment the game's mission count by 1
    game = self.round.game
    game.mission_count = game.mission_count + 1
    game.save!
    # if the mission was an assassination, set the player to dead
    if !self.target_id.nil?
      target = GamePlayer.find(self.target_id)
      target.alive = false
      target.save!
      game = self.round.game
      game.last_dead = target.id
      game.save!
    end
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
