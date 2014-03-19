class Round < ActiveRecord::Base  
  
	belongs_to :game
	has_many :player_missions
  has_many :users, through: :player_missions

  delegate :living_players, :to => :game

  include GlobalScopingMethods

  def start
    players = self.living_players
    agents = []
    handlers = []
    players.each do |player|
      agents << player
      handlers << player
    end
    missions = Mission.where(level: self.difficulty)
    # if there are more than two players, proceed as usual
    if agents.length > 2
      # check to see if assassinations are enabled
      if self.game.mission_count >= self.game.assassin_threshold
        # get a player for each role
        assassin = agents.pop
        assassin_handler = handlers.shift
        assassin_target = agents.pop
        if assassin != assassin_handler
         assassination = PlayerMission.create(:mission_id => Mission.where(assassination: true).first.id, :game_id => self.game_id, :game_player_id => assassin.id, :round_id => self.id, :handler_id => assassin_handler.id, :target_id => assassin_target.id)          
        else
          new_handler = handlers.shift
          handlers.unshift(assassin_handler)
          assassination = PlayerMission.create(:mission_id => Mission.where(assassination: true).first.id, :game_id => self.game_id, :game_player_id => assassin.id, :round_id => self.id, :handler_id => new_handler.id, :target_id => assassin_target.id)          
        end
        # put the target back in the agents array
        agents << assassin_target
      else
        handlers.unshift(handlers.pop)
      end
      # give each player his mission
      agents.each do |agent|
        handler = handlers.shift
        mission = PlayerMission.create(:mission_id => missions.sample.id, :game_id => self.game_id, :game_player_id => agent.id, :round_id => self.id, :handler_id => handler.id)
      end
      self.reload
      self.brief_agents
    # if there are only two players left, proceed into death match    
    else
      mission = missions.sample
      # get the handler from the last assassinated player
      handler = GamePlayer.find(self.game.last_dead)
      agents.each do |agent|
        PlayerMission.create(:mission_id => mission.id, :game_id => self.game_id, :game_player_id => agent.id, :handler_id => handler.id, :round_id => self.id)
      end
    end
  end

  # method to instruct each mission to text its player
  def brief_agents
    # for each mission
    self.player_missions.each do |mission|
      # call its send_message method
      description = Mission.find(mission.mission_id).description
      # if it's an assassination, generate the description now
      if description == ""
        target = GamePlayer.find(mission.target_id).user.user_name
        description = "Assassinate #{target}"
      end
      phone_number = GamePlayer.find(mission.game_player_id).user.phone_number
      handler = GamePlayer.find(mission.handler_id).user.user_name
      mission.brief(description, phone_number, handler)
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
    puts "Smile, give the audience a bow, and bask in the applause. The round is complete, you have come full circle. Rejoice."
    puts "==============="
    puts Game.all.length
    self.game.start_round

  end

  # testing method for ending round with all missions accepted
  def force_end
    self.player_missions.where(success: nil).each do |mission|
      mission.debrief
    end
  end

end
