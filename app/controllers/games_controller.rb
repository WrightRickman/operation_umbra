class GamesController < ApplicationController

	def index

	end

	def create
		# binding.pry

		name = params["name"]
		max_difficulty = 2

		# binding.pry

		Game.create(name: name, max_difficulty: max_difficulty)
		redirect_to '#current'
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 