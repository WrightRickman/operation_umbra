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
		#check to see if the current user is in a game
		if current_user.involved 
			#if the current user is in a game, return an empty object
			lobby_info = {}
		else
			#get all open games
			open_games = Game.where(started: false)
			#create a players hash
			players = {}
			#create an object in the hash for each game, add the game's players to that object
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
		#check to see if the user is logged in
		if current_user
			#set new_player equal to the id of the current user
			new_player = current_user.id
			#create a new game_player with the current user's id and the game id from params
			game_player = GamePlayer.create(game_id: params[:game_id], user_id: new_player)
			#set the current user to be involved in a game so that they cannot join more
			User.update(new_player, :involved => true)
		end
		respond_to do |format|
			format.html
			format.json {render json: "okay"}
		end
	end

	def current_game
		#check to see if the user is logged in
		if current_user
			#check to see if the user is involved in any games
			if !current_user.games.empty?
				#find the current user's current game
				#this is a messy way of handling the user information. If time allows, should improve both models and relations to allow for cleaner code.
				game = Game.find(current_user.games.first.id)
				player_ids = []
				#add the ide of each player in the game to the player_id's array
				game.users.each do |player|
					player_ids << player.id
				end
			#if the user is not involved in a game, create an empty object to send back to the app
			else
				game = {}
			end
			#create an info object with the game, the game's players, and the current user's id
			info = {game: game, player_ids: player_ids, current_user: current_user.id}
		#if the user is not logged in, create an empty object to send back to the app
		else
			info = {}
		end
		#send the info object to the server
		respond_to do |format|
				format.html
				format.json {render json: info}
			end
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)
	end

end
 