class Game < ActiveRecord::Base
  
	has_many :rounds
  has_many :game_players
  has_many :player_missions
  has_many :users, through: :game_players
  has_many :missions, through: :player_missions

  delegate :living_players, :to => :game_players
  delegate :length, :to => :rounds

  include GlobalScopingMethods

  def self.open
    where(started: false)
  end

  def self.active
    where(completed: false)
  end

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

  def game_stats
    player_ids = []
    self.game_players.each do |player|
      player_ids << player.id
    end
    if self.living_players.length == 2 && self.started
      last_dead = GamePlayer.find(self.last_dead)
    else
      last_dead = nil
    end
    return {game: self, player_ids: player_ids, last_dead: last_dead}
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

  # start round after setting all the current players
  def start_round
    if !self.completed
      difficulty = self.get_current_difficulty
      new_round = Round.create(:game_id => self.id, :difficulty => difficulty, :round_start => Time.now)
      self.reload
      new_round.start(self.living_players)
    end
  end

  # method for ending game
  # called when a round's check_mission_status shows complete with 2 agents in the round
  def end_game(winner)
    self.completed = true
    puts "#{winner.user.user_name} won the game!"
  end

end
