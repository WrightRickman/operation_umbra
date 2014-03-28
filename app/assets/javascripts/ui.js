var App = Backbone.Router.extend({
	// all routes
	routes: {
		"": "home",
		"create": "create",
		"lobby": "lobby",
		"adminStart": "adminStart",
		"current": "current",
		"start": "start",
		"menu": "menu",
		"myGames": "myGames",
		"pastGames": "pastGames",
		"finalMission": "finalMission",
		"rules": "rules",
	},
	home: function(){
		app.gameStatus();
		app.current_page = "home"
	},
	create: function(){
		app.gameStatus("create", app.generateUI);
	},
	lobby: function(){
		// create a new UI.Body so that we can call it's openGames function
		// come back later to find better way to do this
		console.log("Arrived at the Lobby Function")
		app.gameStatus("join", app.generateUI);
		body = new UI.Body();
		body.openGames();
	},
	adminStart: function(){
		app.gameStatus("adminStart", app.generateUI);
	},
	current: function(){
		app.gameStatus("current", app.generateUI);
	},
	start: function(){
		app.gameStatus("start", app.generateUI);
	},
	menu: function(){
		app.gameStatus("menu", app.generateUI);
	},
	myGames: function(){
		app.gameStatus("myGames", app.generateUI);
	},
	pastGames: function(){
		app.gameStatus("pastGames", app.generateUI);
	},
	finalMission: function(){
		app.gameStatus("finalMission", app.generateUI);
	},
	rules: function(){
		app.gameStatus("rules", app.generateUI);
	},
	gameStatus: function(destination, func){
		// makes an ajax call, returning the current user, curren't user's game, and the game's players' ids
		// saves all the information to global variables so that they may be interacted withs
		$.ajax({
			url: "/current_game",
			method: "get",
			dataType: 'json',
			success: function(data){
				console.log(data);
				app.current_user = data.current_user
				app.current_game = data.game
				app.current_players = data.player_ids
				app.handler_mission = data.handler_mission
				func(destination);
			}
		});

		// if (app.current_game.last_dead != null) {
		// 	app.navigate("#finalMission", {trigger: true, replace: true});
		// 	$.ajax({
		// 		url: "/final_mission",
		// 		method: "get",
		// 		dataType: "json",
		// 		success: function(data){
		// 			// app.generateUI("join");
		// 			app.finalTwo = data
		// 		}
		// 	})
		// }
	},
	generateUI: function(destination, func){
		app.current_page = destination
		if (ui) ui.remove();
		var ui = new UI;
		if (func != null) func();
	}
})

// View
var UI = Backbone.View.extend({
	initialize: function(attributes){
		this.render({
			body: new UI.Body()
		});
	},
	el: function(){
		return $('#state_frame');
	},
	render: function(sub_views){
		var self = this;
		this.$el.empty();

		_.each(this.sub_views, function(view){
			view.remove();
		});

		this.sub_views = sub_views;

		_.each(this.sub_views, function(view){
			var view_el = view.render().$el;
			self.$el.append(view_el);
		});

		return this;
	}
})

UI.Body = Backbone.View.extend({
	initialize: function(){
	},
	render: function(){
		this.$el.html(this.template(app.current_page)(app.openGames));
		return this;
	},
	events: {
		// event for creating a new game
		"submit form": "create",
		// event for joining a game
		"click .join_game_button": "joinGame",
		// event redirecting players to lobby if viewing the start page without having joined a game
		"click #return_lobby_button": "goToLobby",
		// event for a player leaving a game
		"click #leave_game_button": "leaveGame",
		// event for a game admin to remove all players and delete the game
		"click #disband_game_button": "disbandGame",
		// event for starting the game
		"click #start_game_button": "startGame",
		// event for a handler accepting an agent's mission
		"click #handler_accept_button": "acceptMission",
		// event for a handler rejecting an agent's mission
		"click #handler_reject_button": "rejectMission",
		// redirect to the create page
		"click #return_create_button": "redirectCreate",
		// redirect to current
		"click #current_game_button": "redirectCurrent"
	},
	create: function(e){
		// function to create a new game
		e.originalEvent.preventDefault();

		var game_name, game_max_difficulty;

		if ($('#agency_name_input').val() == ""){
			game_name = "Operation Umbra"
		}
		else {
			game_name = $('#agency_name_input').val();
		}

		if ($('#end_difficulty_input').val() == "") {
			game_max_difficulty = 2
		}
		else {
			game_max_difficulty = $('#end_difficulty_input').val();
		}

		var params = {
			// add the name of the game
			name: game_name,
			// add the max difficulty as specified by the player
			max_difficulty: game_max_difficulty
		}
		// ajax call to create the game in the database
		$.ajax({
			url: "/create_game",
			method: "post",
			dataType: "json",
			data: params,
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		app.navigate("#adminStart", {trigger: true, replace: true});
	},
	// function to return all open games
	openGames: function(){
		$.ajax({
			url: "/lobby",
			method: "get",
			dataType: "json",
			success: function(data){
				console.log(data);
				//data[0] is the game object
				//data[1] is the game's players' ids
				// set app.openGames equal to the game object returned
				app.openGames = data[0];
				app.generateUI("join", function(){
					if (app.openGames === undefined){
						$('#wrapper').append("<p>We do not allow double agents... You must wait until the current game is over, or drop from the current game.</p>");
					}
				});
				console.log("got this far");
				//recreate the page based on 
				// check to see if the
			}
		})
	},
	joinGame: function(e){
		// get the id of the game joined
		gameID = $(e.target).parent().parent().children().first().html();
		// make an ajax call to have the player join the game
		var params = {
				// send the server the id of the game the user is joining
				game_id: gameID,
			};
		$.ajax({
			url: '/join',
			method: "post",
			data: params,
			dataType: "json",
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		// redirect the player to the start page of their current game
		app.navigate("#start", {trigger: true, replace: true});
	},
	goToLobby: function(e){
		app.navigate("#lobby", {trigger: true, replace: true});
	},
	leaveGame: function(e){
		$.ajax({
			url: "/leave_game",
			method: "post",
			dataType: "json",
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		// redirect player to the lobby
		app.navigate("#lobby", {trigger: true, replace: true});
	},
	disbandGame: function(e){
		$.ajax({
			url: "/disband_game",
			method: "post",
			dataType: "json",
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		app.navigate("#create", {trigger: true, replace: true});
	},
	startGame: function(e){
		$.ajax({
			url: "/start_game",
			method: "post",
			dataType: "json",
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		app.navigate("#current", {trigger: true, replace: true});
	},
	// TODO: In deathmatch mode, handler page has two buttons. There is no failure button here                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	acceptMission: function(e){
		$.ajax({
			url: "/accept_mission",
			method: "post",
			dataType: "json",
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		app.navigate("#start", {trigger: true, replace: true});
	},
	rejectMission: function(e){
		$.ajax({
			url: "/reject_mission",
			method: "post",
			dataType: "json",
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
		})
		app.navigate("#start", {trigger: true, replace: true});
	},
	redirectCreate: function(e){
		app.navigate("#create", {trigger: true, replace: true});
	},
	redirectCurrent: function(e){
		app.navigate("#current", {trigger: true, replace: true});
	},
	template: function(template_name){
		var source;
		// use the template that matches the current route
		switch (template_name) {
			case "home":
				console.log('home');
				source = $('#home-template').html();
				break;
			case "create":
				if ($.isEmptyObject(app.current_game) == false){
					console.log('in game already');
					source = $('#in-game-template').html();
				}
				else {
					console.log('create');
					source = $('#create-template').html();
				}
				break;
			case "join":
				console.log('join');
				source = $('#join-template').html();
				break;
			case "current":
				// if the game has started
				if (app.current_game.started == true) {
					if (app.handler_mission.success == null) {
						console.log('handler');
						source = $('#handler-template').html();
					}
					else {
						console.log('between handles');
						source = $('#mission-accepted-template').html();
					}
				}
				// the game has not started, but the user is the creator
				else if (app.current_game.creator_id == app.current_user) {
					console.log("current creator");
					source = $('#creator-start-template').html();
				}
				// the game has not started, but the user is in the game
				else if ($.inArray(app.current_user, app.current_players) != -1){
					console.log('current player')
					source = $('#player-start-template').html();
				}
				// user is not in the game
				else {
						source = $('#nobody-start-template').html();
						console.log('current nobody')
				}
				break;
			case "start":
				console.log('start');
				// find the template that matches whether the user is the game's creator, one of the game's players, or else someone viewing the page without having joined the game
				// if the game has started
				if (app.current_game.started == true) {
					console.log('this is undefined')
					source = $('#game-started-template').html();
				}
				// if the user is logged in and is the creator of the current game
				else if (app.current_user == app.current_game.creator_id || undefined) {
						console.log('admin')
						source = $('#admin-start-template').html();
				}
				// if the user is logged in, a player of the current game, but not the admin
				else if ($.inArray(app.current_user, app.current_players) != -1) {
						console.log('player')
						source = $('#player-start-template').html();
					}
				// user is not in a game
				else {
						source = $('#nobody-start-template').html();
						console.log('nobody')
				}
				break;
			case "finalMission":
				if (app.current_user == app.current_game.last_dead) {
					console.log('final mission')
					source = $('#final-mission-template').html();
				}
				// FOR THE FUTURE
				// else {
				// 	console.log('please wait')
				// 	source = $('#mission-accepted-template').html();
				// }
			case "rules":
				console.log('rules')
				source = $('#rules-template').html();
				break;
			case "adminStart":
				console.log('admin')
				source = $('#admin-start-template').html();
				break;
			case "menu":
				console.log('menu');
				source = $('#menu-template').html();
				break;
			case "myGames":
				console.log('myGames');
				source = $('#myGames-template').html();
				break;
			case "pastGames":
				console.log('pastGames');
				source = $('#pastGames-template').html();
				break;
			default: 
				console.log('else');		
		}

		var template = Handlebars.compile(source);
		return template;
	}
})

$(function(){
	window.app = new App();
	Backbone.history.start();
})