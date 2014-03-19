class PlayerMission < ActiveRecord::Base
  
  belongs_to :game_player
	belongs_to :round
	belongs_to :mission
  has_many :users, through: :game_player

  include GlobalScopingMethods

  def self.find_by_handler(game_player)
    where(handler_id: game_player.id)
  end

  # returns the handler of the mission
  def handler
    GamePlayer.find(self.handler_id)
  end

  def target
    GamePlayer.find(self.target_id)
  end

  # method for sending the player their mission... still coming
  def brief(description, phone_number, handler)
    account_sid = 'ACe3077fe23fe1139751ed954c6a9ca95a'
    auth_token = '03fda3cb1fb25da94e121f1747972a02'
    @client = Twilio::REST::Client.new account_sid, auth_token

    message = @client.account.sms.messages.create(:body => "<~Attn Agent~> \n Your Mission: #{description} \n #{handler} is overseeing your mission. Complete your mission and bring them proof." ,
    :to => "+1#{phone_number}",    
    :from => "+19177465955")  
    # puts message.sid
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
    handler_player = GamePlayer.find(self.handler_id)
    handler_player.points = handler_player.points + 1
    handler_player.save!
    # Increment the game's mission count by 1
    game = self.round.game
    game.mission_count = game.mission_count + 1
    game.save!
    # if the mission was an assassination, set the player to dead
    if !self.target_id.nil?
      self.target.assassinated
      game = self.round.game
      game.save!
      game.reload
    end
    # check to see if the round was a deathmatch
    if self.round.player_missions.length == 2
      # if the round was a deathmatch, the player won!
      self.round.game.end_game(self.game_player)
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
