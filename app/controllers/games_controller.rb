class GamesController < ApplicationController

	def index

	end

	def create
		#only create a game if a user is signed in
		if current_user
			new_game = Game.create(name: params["name"], max_difficulty: max_difficulty, creator_id: current_user.id)
			current_user.assign_current_game(new_game)
			#create a hash to return to the app, with the created game and the creator's id
			info = {game: new_game, user: current_user.id}
		end

		respond_to do |format|
			format.html
			format.json {	render json: info }
		end
	end

	def lobby
		#check to see if the current user is in a game
		if current_user.current_game
			#if the current user is in a game, return an empty object
			lobby_info = {}
		else
			lobby_info = Game.open_games_and_players
		end

		respond_to do |format|
			format.json {render json: lobby_info}
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

	def current_game
		#if user is signed in
		if current_user
			# if the user is in a game, get the game stats and save it to the info hash
			if !current_user.current_game
				game = Game.find(current_user.current_game)
				users_game_player = GamePlayer.find_by_user(current_user).find_by_game(game).first
				info = game.game_stats
				info[:current_user] = current_user.id
				info[:handler_mission] = PlayerMission.find_by_handler(users_game_player).last
			#if the user is not involved in a game, create an empty object to send back to the app
			else
				info = {game: {}, player_ids: [], current_user: current_user.id, handler_mission: [], last_dead: []}
			end
		else
			info = {}
		end
		#send the info object to the server
		respond_to do |format|
				format.html
				format.json {render json: info}
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

	def disband_game
		# if the current user is in a game, disband it
		if current_user.current_game != nil
			current_user.current_game.disband_game
		end

		respond_to do |format|
			format.html
			format.json {render json: {}}
		end
	end

	def start
		if current_user.current_game != nil
			current_user.current_game.start
		end

		respond_to do |format|
			format.html
			format.json {render json: {}}
		end
	end

	def accept_mission
		if current_user.current_game != nil
			current_user.current_player.accept_mission
		end

		respond_to do |format|
			format.html
			format.json {render json: {}}
		end
	end

		def reject_mission
		if current_user.current_game != nil
			current_user.current_player.reject_mission
		end

		respond_to do |format|
			format.html
			format.json {render json: {}}
		end
	end

	def final_mission
		respond_to do |format|
			format.html
			format.json {render json: {}}
		end 
	end

	private

	def game_params
		params.require(:game).permit(:assassin_threshold, :min_difficulty, :max_difficulty, :mission_count, :started, :completed, :time_limit, :name)
	end

end
 