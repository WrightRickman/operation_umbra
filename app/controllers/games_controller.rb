class GamesController < ApplicationController

	def index

	end

	def create
		# binding.pry

		name = params["name"]
		max_difficulty = params["max_difficulty"]

		# binding.pry

		game = Game.create(name: name, max_difficulty: max_difficulty)
		current_user = current_user.id
		info = {game: game, user: current_user}

		respond_to do |format|
			format.html
			format.json {	render json: info }
		end
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 