class UsersController < ApplicationController

  def create
    #only create a game if a user is signed in
    if current_user
      #create a hash that includes a new game and the current user
      info = {game: current_user.new_game(params["name"], params["max_difficulty"]), user: current_user.id, params["assassin_threshold"]}
    end

    respond_to do |format|
      format.html
      format.json { render json: info }
    end
  end

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
