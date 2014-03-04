class Round < ActiveRecord::Base  
  
	belongs_to :game
	has_many :player_missions
  has_many :users, through: :player_missions

  def start(players)
    # set @players to all the round's players
    @players = players
    # set @agents to a randomized array of all players
    @agents = @players.shuffle
    # set @unassigned_handlers to a randomized array of all players
    @handlers = @players.shuffle
    @unassigned_handlers = @handlers.shuffle
    # get all missions of round difficulty
    missions = Mission.where(level: self.difficulty)

    # if there are more than two players, proceed as usual
    if @agents.length > 2
      # check to see if assassinations are enabled
      if self.game.mission_count >= self.game.assassin_threshold
        # find an assassin, handler and target
        assassin = @agents.pop
        # handler and target popped so to guarantee they are not the same player
        assassin_handler = @agents.pop
        assassin_target = @agents.pop
        # create the mission
        @assassination = PlayerMission.create(:mission_id => Mission.where(assassination: true).first.id, :game_id => self.game_id, :game_player_id => assassin.id, :round_id => self.id, :handler_id => assassin_handler.id, :target_id => assassin_target.id)
        # put the handler and assassin back in the @agents array and shuffled it
        @agents << assassin_handler
        @agents << assassin_target
        @agents.shuffle!
        # remove that handler from @handlers, and reset unassigned handlers
        @handlers.delete(assassin_handler)
        @unassigned_handlers = @handlers.shuffle!
      end
      # give each player his mission
      @agents.each do |agent|
        # create the mission
        mission = PlayerMission.create(:mission_id => missions.sample.id, :game_id => self.game_id, :game_player_id => agent.id, :round_id => self.id)
      end
      # assign the handlers
      self.assign_all_handlers
      self.reload
      # send the texts
      self.brief_agents
    # if there are only two players left, proceed into death match    
    else
      # get a mission
      mission = missions.sample
      # get the handler from the last assassinated player
      handler = GamePlayer.find(self.game.last_dead)
      # create the mission for each
      @agents.each do |agent|
        PlayerMission.create(:mission_id => mission.id, :game_id => self.game_id, :game_player_id => agent.id, :handler_id => handler.id, :round_id => self.id)
      end
    end
  end

  # method to assign handlers to each mission
  def assign_all_handlers
    # go through each mission
    self.player_missions.each do |mission|
      # and assign it a handler
      assign_handler(mission)
    end
    # check to make sure that all handlers were set out
    if !check_handler_distribution
      # if test failed, start over
      @unassigned_handlers = @handlers.shuffle
      self.assign_all_handlers
    end
  end

  # method to assign handlers to a specific mission
  def assign_handler(mission)
    # get an unassigned handler
    handler = @unassigned_handlers.last
    # check to make sure you aren't assigning a handler to itself
    if handler != mission.user
      mission.handler_id = handler.id
      mission.save!
      # remove it from the list of unassigned handlers
      @unassigned_handlers.pop
    else
      # if the handler and the missions's agent are the same, try again
      assign_handler(mission)
    end
  end

  # method to verify that no agent is assigned itself as a handler
  def check_handler_distribution
    # set result to true
    result = true
    # check each mission
    self.player_missions.each do |mission|
      # only evaluate if the mission is not an assassination
      if mission != @assassination
        # if the mission's handler is the same as its agent, switch result to false
        if mission.game_player_id == mission.handler_id
          result = false
        # elsif mission.handler.player_missions.last.handler == 
        end
      end
    end
    # return the result
    return result
  end

  # method to instruct each mission to text its player
  def brief_agents
    # for each mission
    self.player_missions.each do |mission|
      # call its send_message method
      message = Mission.find(mission.mission_id).description
      phone_number = User.find(mission.user_id).phone_number
      handler = User.find(mission.handler_id).user_name
      mission.brief(message, phone_number, handler)
    end
  end

  # method for checking if all the round's missions have been completed
  # called by PlayerMissions's debrief method
  def check_missions_status
    # set completeness to default
    completeness = true
    # test each of the round's missions
    self.player_missions.each do |mission|
      # if the mission is not complete, set completeness to nil
      if mission.success.nil?
        completeness = false
      end
    end
    # if the round is over, call the end round method
    if completeness
      # if there are only two agents and the round is complete
      self.end_round
    end
  end

  # metho to end the round
  def end_round
    # set the rounds end time to current time
    self.round_end = Time.now
    self.save!
    # tell the game to start a new round
    self.game.start_round
    puts "Smile, give the audience a bow, and bask in the applause. The round is complete, you have come full circle. Rejoice."
  end

  # testing method for ending round with all missions accepted
  def force_end
    self.player_missions.each do |mission|
      mission.debrief
    end
  end

end



















