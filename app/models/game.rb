class Game < ActiveRecord::Base
	has_many :rounds
  has_many :game_players
  has_many :player_missions
  has_many :users, through: :game_players
  has_many :missions, through: :player_missions

  #return all living players
  def find_living_players
    living = []
    # create an array of all the game's players
    all_players = self.game_players
    # check if each player is alive, and if so, add to living array
    all_players.each do |player|
      if player.alive
        living << player
      end
    end
    # return the array of living players
    return living
  end

  def get_current_difficulty
    # check to see if max difficulty has been reached yet
    if self.rounds.length + 1 < self.max_difficulty
      # if max difficulty has not been reached, return the round number
      return self.rounds.length + 1
    else
      # else return the max_difficulty
      return self.max_difficulty
    end
  end

  def start_game
    # set game to having been started
    self.started = true
    # start a round
    start_round
    self.reload
  end

  def start_round
    # create a new round, setting it's game id, max difficulty, and start time
    new_round = Round.create(:game_id => self.id, :difficulty => self.get_current_difficulty, :round_start => Time.now)
    # call the new round's start method, passing it a list of living players
    # new_round.start(self.find_living_players)
    self.reload
  end

end
