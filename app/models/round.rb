class Round < ActiveRecord::Base
	belongs_to :game
	has_many :player_missions
  has_many :users, through: :player_missions

  def start(players)
    # if there are more than two players, proceed as usual
    if players.length > 2
      # self.find_living_players.each do |player|

      # end
      puts "there are #{players.length} living players!"
    # if there are only two players left, proceed into death match    
    else
      puts "there are two living players!"
    end
  end

end