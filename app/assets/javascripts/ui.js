var App = Backbone.Router.extend({
	// all routes
	routes: {
		"": "home",
		"create": "create",
		"join": "join",
		"start": "start",
		"current": "current",
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
		var ui = new UI();
	},
	join: function(){
		// create a new UI.Body so that we can call it's openGames function
		// come back later to find better way to do this
		var body = new UI.Body();
		body.openGames();
	},
	start: function(){
		app.current_page = "start"
		if (ui) ui.remove();
		var ui = new UI();
	},
	current: function(){
		app.current_page = "current"
		if (ui) ui.remove();
		var ui = new UI();
	},
	menu: function(){
		app.current_page = "menu"
		if (ui) ui.remove();
		var ui = new UI();
	},
	myGames: function(){
		app.current_page = "myGames"
		if (ui) ui.remove();
		var ui = new UI();
	},
	pastGames: function(){
		app.current_page = "pastGames"
		if (ui) ui.remove();
		var ui = new UI();
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
		console.log(this);
		console.log(this.template(app.current_page));
		console.log(app.openGames);
		this.$el.html(this.template(app.current_page)(app.openGames))
		return this;
	},
	events: {
		"submit form": "create"
	},
	create: function(e){
		// function to create a new game
		console.log(e.originalEvent)
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
			beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}, beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
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
				app.openGames = data;
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
			case "start":
				console.log('start');
				source = $('#start-template').html();
				break;
			case "current":
				console.log('current');
				source = $('#current-template').html();
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