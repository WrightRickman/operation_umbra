class GamesController < ApplicationController

	def index

	end

	def create
		respond_to do |format|
			format.json do
				game = Game.create(game_params)
				render :json => game.to_json
			end
		end

		redirect_to '#join'
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 