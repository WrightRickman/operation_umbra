class GamesController < ApplicationController

	def index

	end

	def create

	end

	private

	# strong params go here
	def game_parameters
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 