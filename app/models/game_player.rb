class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :player_missions

  include GlobalScopingMethods

  ############ QUERYING METHODS #############

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
  ###########################################

  ########### MISSION HANDLING METHODS #########

  def accept_mission
    self.handler_mission.debrief
  end

  def reject_mission
    self.handler_mission.failure
  end

  #################################################

  ########### CREATION AND DEATH METHODS ###########

  def assassinated
    self.alive = false
    self.save!
    self.user.remove_current_game
  end

  ##################################################

end
