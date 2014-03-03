Game.destroy_all
User.destroy_all
GamePlayer.destroy_all
Mission.destroy_all
Round.destroy_all
PlayerMission.destroy_all

yaniv = User.create(:user_name => "Yaniv", :email => "yaniv@email.com", :password => "password123", :phone_number => "9736193328")
this_game = Game.create(:name => "The Tenth Plaguers", :max_difficulty => 3, :creator_id => yaniv.id)
yaniv.current_game = this_game.id
yaniv.save!
GamePlayer.create()
wright = User.create(:user_name => "Wright", :email => "wright@email.com", :password => "password456", :phone_number => "5166552432", :current_game => this_game.id)
bushkanets = User.create(:user_name => "Danny", :email => "danny@email.com", :password => "password123", :phone_number => "5551234567", :current_game => this_game.id)
princess_pretzel = User.create(:user_name => "Brittany", :email => "brittany@email.com", :password => "password123", :phone_number => "5552345678", :current_game => this_game.id)
GamePlayer.create(:user_id => yaniv.id, :game_id => this_game.id)
GamePlayer.create(:user_id => wright.id, :game_id => this_game.id)
GamePlayer.create(:user_id => bushkanets.id, :game_id => this_game.id)
GamePlayer.create(:user_id => princess_pretzel.id, :game_id => this_game.id)