module GlobalScopingMethods

  module ClassMethods

    def find_by_user(user)
      where(user_id: user.id)
    end

    def find_by_game(game)
      where(game_id: game.id)
    end

    def find_by_game_player(game_player)
      where(game_player_id: game_player.id)
    end

    def find_by_player_mission(player_mission)
      where(player_mission_id: player_mission.id)
    end

    def find_by_mission(mission)
      where(mission_id: mission.id)
    end
  end

  def self.included(including_class)
    including_class.extend ClassMethods
  end

end