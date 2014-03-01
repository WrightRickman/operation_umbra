Game.destroy_all

yaniv = User.create(:user_name => "Yaniv", :email => "yaniv@email.com", :password => "password123")
Game.create(:name => "The Tenth Plaguers", :max_difficulty => 3, :creator_id => yaniv.id)