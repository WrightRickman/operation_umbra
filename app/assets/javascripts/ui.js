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
		// redirect logic
	},
	create: function(){
		app.current_page = "create"
		if (ui) ui.remove();
		var ui = app.generateUI();
	},
	lobby: function(){
		// create a new UI.Body so that we can call it's openGames function
		// come back later to find better way to do this
		var body = new UI.Body();
		body.openGames();
	},
	adminStart: function(){
		app.current_page = "adminStart"
		if (ui) ui.remove();
		var ui
		app.generateUI();
	},
	current: function(){
		app.current_page = "current"
		if (ui) ui.remove();
		var ui = app.generateUI();
		$.ajax({
			url: '/current_game',
			method: 'get',
			dataType: 'json',
			success: function(data){
				console.log(data)
				app.current_game = data["game"]
			}
		})
	},
	start: function(){
		app.current_page = "start"
		if (ui) ui.remove();
		var ui
		app.generateUI();
	},
	menu: function(){
		app.current_page = "menu"
		if (ui) ui.remove();
		var ui
		app.generateUI();
	},
	myGames: function(){
		app.current_page = "myGames"
		if (ui) ui.remove();
		var ui
		app.generateUI();
	},
	pastGames: function(){
		app.current_page = "pastGames"
		if (ui) ui.remove();
		var ui
		app.generateUI();
	},
	generateUI: function(){
		$.ajax({
			url: "/current_game",
			method: "get",
			dataType: 'json',
			success: function(data){
				app.current_user = data.current_user
				app.current_game = data.game
				app.current_players = data.player_ids
				ui = new UI;
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
		"submit form": "create",
		"click .join_game_button": "joinGame"
	},
	create: function(e){
		// function to create a new game
		e.originalEvent.preventDefault();

		var params = {
			name: $('#agency_name_input').val(),
			max_difficulty: $('#end_difficulty_input').val()
		}

		$.ajax({
			url: "/games",
			method: "post",
			dataType: "json",
			data: params,
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
			success: function(data){
				// app.current_game = data;
				console.log(data)
				app.start();
			}
		})
	},
	// function to return all open games and save it to app.openGames
	openGames: function(){
		$.ajax({
			url: "/lobby",
			method: "get",
			dataType: "json",
			success: function(data){
				console.log(data)
				app.openGames = data[0];
				app.current_page = "join"
				if (ui) ui.remove();
				var ui = new UI();
				if (app.openGames.lobby === null){
					$('#wrapper').append("<p>We do not allow double agents... You must wait until the current game is over, or drop from the current game.</p>")
				}
			}
		})
	},
	joinGame: function(e){
		$target = $(e.target);
		gameID = $target.parent().parent().children().first().html();
		var params = {
				game_id: gameID,
			};
		$.ajax({
			url: '/join',
			method: "post",
			data: params,
			dataType: 'json',
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
			success: function(data){
				app.current_page = "join"
				if (ui) ui.remove();
				var ui = new UI();
			}

		})
	},
	template: function(template_name){
		var source;
		switch (template_name) {
			case "home":
				console.log('home');
				source = $('#create').html();
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
				if (app.current_user === null){
					source = $('#nobody-start-template').html();
				}
				else {
					if (app.current_user == app.current_game.creator_id){
						source = $('#admin-start-template').html();
					}
					else {
						source = $('#player-start-template').html();
					}
				}
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