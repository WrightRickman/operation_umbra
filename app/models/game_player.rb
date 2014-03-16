class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :player_missions

  include GlobalScopingMethods

  def self.living_players
    where(alive: true)
  end

  def self.active
    
  end

  def create_game_admin(game)
    GamePlayer.create(user_id: current_user.id, game_id: game.id)
  end

end
