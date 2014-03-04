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
		"pastGames": "pastGames"
	},
	home: function(){
		app.generateUI();
		app.current_page = "home"
	},
	create: function(){
		app.generateUI();
		app.current_page = "create"
		if (ui) ui.remove();
		var ui = new UI;
	},
	lobby: function(){
		// create a new UI.Body so that we can call it's openGames function
		// come back later to find better way to do this
		app.generateUI();
		app.current_page = "lobby"
		var body = new UI.Body();
		body.openGames();
	},
	adminStart: function(){
		app.generateUI();
		app.current_page = "adminStart"
		if (ui) ui.remove();
		var ui = new UI;
	},
	current: function(){
		app.generateUI();
		app.current_page = "current"
		if (ui) ui.remove();
		var ui = new UI;
	},
	start: function(){
		app.generateUI();
		app.current_page = "start"
		if (ui) ui.remove();
		var ui = new UI;
	},
	menu: function(){
		app.current_page = "menu"
		if (ui) ui.remove();
		var ui = new UI;
		app.generateUI();
	},
	myGames: function(){
		app.generateUI();
		app.current_page = "myGames"
		if (ui) ui.remove();
		var ui = new UI;
	},
	pastGames: function(){
		app.generateUI();
		app.current_page = "pastGames"
		if (ui) ui.remove();
		var ui = new UI;
	},
	generateUI: function(){
		// makes an ajax call, returning the current user, curren't user's game, and the game's players' ids
		// saves all the information to global variables so that they may be interacted withs
		$.ajax({
			url: "/current_game",
			method: "get",
			dataType: 'json',
			success: function(data){
				app.current_user = data.current_user
				app.current_game = data.game
				app.current_players = data.player_ids
			}
		})
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
		this.$el.html(this.template(app.current_page)(app.openGames))
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
		"click #handler_reject_button": "rejectMission"
	},
	create: function(e){
		// function to create a new game
		e.originalEvent.preventDefault();

		var params = {
			// add the name of the game
			name: $('#agency_name_input').val(),
			// add the max difficulty as specified by the player
			max_difficulty: $('#end_difficulty_input').val()
		}
		// ajax call to create the game in the database
		$.ajax({
			url: "/games",
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
				//data[0] is the game object
				//data[1] is the game's players' ids
				// set app.openGames equal to the game object returned
				app.openGames = data[0];
				//recreate the page based on 
				app.current_page = "join"
				if (ui) ui.remove();
				var ui = new UI();
				// check to see if the
				if (app.openGames.lobby === null){
					$('#wrapper').append("<p>We do not allow double agents... You must wait until the current game is over, or drop from the current game.</p>")
				}
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
	template: function(template_name){
		var source;
		// use the template that matches the current route
		switch (template_name) {
			case "home":
				console.log('home');
				source = $('#home-template').html();
				break;
			case "create":
				console.log('create');
				source = $('#create-template').html();
				break;
			case "join":
				console.log('join');
				source = $('#join-template').html();
				break;
			case "current":
				console.log('current');
				source = $('#current-template').html();
				break;
			case "start":
				console.log('start');
				// find the template that matches whether the user is the game's creator, one of the game's players, or else someone viewing the page without having joined the game
				// if the current user is not logged in

				if (app.current_game.started == true) {
					console.log('this is undefined')
					source = $('#game-started-template').html();
				}
				else if (app.current_user == app.current_game.creator_id || undefined) {
						console.log('admin')
						source = $('#admin-start-template').html();
				}
				else if ($.inArray(app.current_user, app.current_players) != -1) {
						console.log('player')
						source = $('#player-start-template').html();
					}
				else {
						source = $('#nobody-start-template').html();
						console.log('nobody')
				}
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