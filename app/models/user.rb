class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :game_players
	has_many :player_missions, through: :game_players
  has_many :games, through: :game_players

  def assign_current_game(game)
    self.current_game = game.id
    self.save!
  end

end
