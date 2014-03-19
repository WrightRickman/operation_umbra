class Game < ActiveRecord::Base
  
	has_many :rounds
  has_many :game_players
  has_many :player_missions
  has_many :users, through: :game_players
  has_many :missions, through: :player_missions

  delegate :length, :to => :rounds

  include GlobalScopingMethods


###############  QUERYING METHODS #############

  # get all games that haven't started
  def self.open_games
    where(started: false)
  end

  def current_round
    self.rounds.last
  end

  # get the number of current rounds, add 1 to accomodate math in difficulty check
  def total_rounds
    self.rounds.length + 1
  end

  def living_players
    GamePlayer.living_players(self)
  end

  def last_dead
    GamePlayer.last_dead(self)
  end

############################################

###############  CREATE/LOBBY METHODS #############

  # creates a new game
  def self.new_game(name, max_difficulty, creator, assassin_threshold = 8)
    new_game = Game.create(:name => name, :max_difficulty => max_difficulty, :creator_id => creator.id, :assassin_threshold => assassin_threshold)
    creator.join_game(new_game)
    return new_game
  end

  # create a hash of for each open game that contains the users signed up for that game
  def self.open_games_and_players
    players = {}
    self.open_games.each do |game|
      players["#{game.id}"] = []
      game.users.each do |user|
        players["#{game.id}"] << user.id
      end
    end
    lobby = {lobby: self.open_games}
    lobby_info = [lobby, players]
  end

  # create a hash with the game's current stats:
  # which players are playing
  # which game is it
  # who the most recent dead is
  def game_stats
    player_ids = []
    self.game_players.each do |player|
      player_ids << player.user.id
    end
    if self.living_players.length == 2 && self.started
      last_dead = self.last_dead
    else
      last_dead = nil
    end
    return {game: self, player_ids: player_ids, last_dead: last_dead, creator: self.creator_id}
  end

  # destroy the game after unassigning all players
  def disband_game
    self.game_players.each do |player|
      player.user.leave_game
      player.user.save!
    end
    self.destroy
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

############################################

###############  GAME FUNCTION METHODS #############

  # get difficulty, returning the max difficulty if it has been reached
  def get_current_difficulty
    self.reload
    if self.total_rounds < self.max_difficulty
      return self.total_rounds
    else
      return self.max_difficulty
    end
  end

  # start round after setting all the current players
  def start_round
    if !self.completed
      difficulty = self.get_current_difficulty
      new_round = Round.create(:game_id => self.id, :difficulty => difficulty, :round_start => Time.now)
      self.reload
      new_round.start
    end
  end

  # method for ending game
  # called when a round's check_mission_status shows complete with 2 agents in the round
  def end_game(winner)
    self.completed = true
    self.save!
    self.living_players.each do |player|
      if player != winner
        player.assassinated
      else
        player.user.remove_current_game
      end
    end
    puts "#{winner.user.user_name} won the game!"
  end

end
