class Game < ActiveRecord::Base
  
	has_many :rounds
  has_many :game_players
  has_many :player_missions
  has_many :users, through: :game_players
  has_many :missions, through: :player_missions

  scope :open, where(started: false)

  delegate :alive, :to => :game_players
  delegate :length, :to => :rounds

  @living_players = []

  # create a hash of for each open game that contains the users signed up for that game
  def self.open_games_and_players
    players = {}
    self.open.each do |game|
      players["#{game.id}"] = []
      game.users.each do |user|
        players["#{game.id}"] << user.id
      end
    end
    lobby = {lobby: self.open}
    lobby_info = [lobby, players]
  end

  # start game. Only starts with 3+ players
  def start_game
    if self.game_players.length >= 3
      if !self.started
        self.started = true
        self.save
        start_round
      end
    end
  end

  # get difficulty, returning the max difficulty if it has been reached
  def get_current_difficulty
    self.reload
    if self.length + 1 < self.max_difficulty
      return self.length + 1
    else
      return self.max_difficulty
    end
  end

  #return all living players
  def set_living_players
    @living_players = []
    self.alive.each do |player|
      @living_players << player
    end
  end


  # start round after setting all the current players
  def start_round
    if !self.completed
      self.set_living_players
      difficulty = self.get_current_difficulty
      new_round = Round.create(:game_id => self.id, :difficulty => difficulty, :round_start => Time.now)
      self.reload
      new_round.start(@living_players)
    end
  end

  # method for ending game
  # called when a round's check_mission_status shows complete with 2 agents in the round
  def end_game(winner)
    self.completed = true
    puts "#{winner.user.user_name} won the game!"
  end

end
