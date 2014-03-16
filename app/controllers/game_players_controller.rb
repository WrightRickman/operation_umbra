class GamePlayersController < ApplicationController

  # registers the agent's mission as complete
  def accept_mission
    if current_user.current_game != nil
      current_user.current_player.accept_mission
    end

    respond_to do |format|
      format.html
      format.json {render json: {}}
    end
  end

  # registers the agent's mission as failed
  def reject_mission
    if current_user.current_game != nil
      current_user.current_player.reject_mission
    end

    respond_to do |format|
      format.html
      format.json {render json: {}}
    end
  end

end
