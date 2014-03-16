class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :game_players
	has_many :player_missions, through: :game_players
  has_many :games, through: :game_players

  include GlobalScopingMethods

  def assign_current_game(game)
    self.current_game = game.id
    self.save!
  end

  def join_game(game)
    game_player = GamePlayer.create(game_id: game.id, user_id: self.id)
    self.current_game_id = game.id
    self.save!
  end

  def current_game
    Game.find(self.current_game_id)
  end

  def current_player
    GamePlayer.where(user_id: self.id, game_id: self.current_game_id).take
  end

  def leave_game
    self.current_player.destroy
    self.current_game_id = nil
    self.save!
  end

end
