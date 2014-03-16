class UsersController < ApplicationController

  def join_game
    # create a new game player for current use and adjust user appropriately
    if current_user
      current_user.join_game(Game.find(params[:game_id]))
    end

    respond_to do |format|
      format.html
      format.json {render json: "okay"}
    end
  end

  def leave_game
    # if user is in a game, call it's leave game method
    if current_user.current_game != nil
      self.leave_game
    end

    respond_to do |format|
      format.html
      format.json {render json: {}}
    end 
  end

end
