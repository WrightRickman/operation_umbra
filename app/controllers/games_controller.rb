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
		if current_user.involved 
			lobby_info = {}
		else
			#get all open games
			open_games = Game.where(started: false)
			players = {}

			open_games.each do |game|
				players["#{game.id}"] = []
				game.users.each do |user|
					players["#{game.id}"] << user.id
				end
			end
		end

		#pack up all that information in a hash ready for handlebars
		# lobby = {lobby: {open_games: open_games, creators: creators}}
		lobby = {lobby: open_games}
		lobby_info = [lobby, players]
		respond_to do |format|
			format.json {render json: lobby_info}
		end
	end

	def join_game
		if current_user
			new_player = current_user.id
			game_id = params[:game_id]
			# game = Game.find(game_id)
			game_player = GamePlayer.create(game_id: game_id, user_id: new_player)

			User.update(new_player, :involved => true)
		end
		respond_to do |format|
			format.html
			format.json {render json: "okay"}
		end
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)

	end

end
 