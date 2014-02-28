var App = Backbone.Router.extend({
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
		app.current_page = "join"
		if (ui) ui.remove();
		var ui = new UI();
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
		this.$el.html(this.template({}, app.current_page));

		if (app.current_page == "join") {
			console.log("Oh hai Mark!")
		} 
		else if (app.current_page == "current") {
			console.log("Oh hai Denny!")
		}
		else if (app.current_page == "myGames") {
			console.log("Oh hai Doggie!")
		}
		else if (app.current_page == "pastGames") {
			console.log("Lisa, YOU ARE TEARING ME A PART!")
		}

		return this;
	},
	events: {
		"click #create_game_submit": "create"
	},
	create: function(e){
		e.preventDefaut();

		var params = {
			name: $('#agency_name_input').val(),
			difficulty: $('end_difficulty_input').val()
		}

		$.ajax({
			url: "/create",
			method: "post",
			dataType: "json",
			data: params,
			success: function(){
				app.current;
			}
		})
	},
	template: function(attributes, template_name){
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