class GamesController < ApplicationController

	def index

	end

	def create
		# binding.pry

		name = params["name"]
		max_difficulty = params["max_difficulty"]

		game = Game.create(name: name, max_difficulty: max_difficulty)
		info = {game: game}
		if current_user
			info[user: current_user.id]
		end

		respond_to do |format|
			format.html
			format.json {	render json: info }
		end
	end

	def lobby
		open_games = Game.where(started: false)
		lobby = {open_games: open_games}
		respond_to do |format|
			format.json {render json: lobby}
		end
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 