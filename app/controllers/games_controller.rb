class GamesController < ApplicationController

	def index

	end

	def create
		#if the user is logged in...
		if current_user
			#save params to variables
			name = params["name"]
			max_difficulty = params["max_difficulty"]
			#create the game
			game = Game.create(name: name, max_difficulty: max_difficulty, creator_id: current_user.id)
			#create a hash to return to the app, with the created game and the creator's id
			info = {game: game, user: current_user.id}
		end

		respond_to do |format|
			format.html
			format.json {	render json: info }
		end
	end

	def lobby
		#get all open games
		open_games = Game.where(started: false)
		#create a hash for creators
		creators = []
		#add the creator of each game to the creators hash
		open_games.each do |game|
			creators << User.find(game.creator_id)
		end
		#pack up all that information in a hash ready for handlebars
		lobby = {lobby: {open_games: open_games, creators: creators}}
		respond_to do |format|
			format.json {render json: lobby}
		end
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 