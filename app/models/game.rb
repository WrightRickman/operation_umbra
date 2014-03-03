class Game < ActiveRecord::Base
  
	has_many :rounds
  has_many :game_players
  has_many :player_missions
  has_many :users, through: :game_players
  has_many :missions, through: :player_missions

  @living_players = []

  #return all living players
  def set_living_players
    # reset living_players
    @living_players = []
    # create an array of all the game's players
    all_players = self.game_players

    # check if each player is alive, and if so, add to living array
    all_players.each do |player|
      if player.alive
        @living_players << player
      end
    end
  end

  def get_current_difficulty
    self.reload
    # check to see if max difficulty has been reached yet
    if self.rounds.length + 1 < self.max_difficulty
      # if max difficulty has not been reached, return the round number
      return self.rounds.length + 1
    else
      # else return the max_difficulty
      return self.max_difficulty
    end
  end

  # method for starting game
  def start_game
    # set game to having been started
    self.started = true
    # start a round
    start_round
    self.reload
  end

  # method for ending game
  # called when a round's check_mission_status shows complete with 2 agents in the round
  def end_game(winner)
    puts "#{winner.user_name} won the game!"
  end

  def start_round
    # update living players
    self.set_living_players
    # create a new round, setting it's game id, max difficulty, and start time
    new_round = Round.create(:game_id => self.id, :difficulty => self.get_current_difficulty, :round_start => Time.now)
    self.reload
    # call the new round's start method, passing it a list of living players
    new_round.start(@living_players)
  end

end
