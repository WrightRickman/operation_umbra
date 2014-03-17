class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :player_missions

  include GlobalScopingMethods

  def self.living_players(game)
    where(alive: true)
  end

  def self.dead_players
    where(alive: false)
  end

  def self.last_dead(game)
    self.dead_players.where(game_id: game.id).order("updated_at DESC").last
  end

  def current_mission
    self.player_missions.last
  end

  def handler_mission
    PlayerMission.where(handler_id: self.id).last
  end

  def accept_mission
    self.handler_mission.debrief
  end

  def reject_mission
    self.handler_mission.failure
  end

  def create_game_admin(game)
    GamePlayer.create(user_id: current_user.id, game_id: game.id)
  end

end
