class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :player_missions
  scope :alive, where(alive: true)

  def create_game_admin(game)
    GamePlayer.create(user_id: current_user.id, game_id: game.id)
  end

end
