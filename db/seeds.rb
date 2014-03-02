Game.destroy_all

yaniv = User.create(:user_name => "Yaniv", :email => "yaniv@email.com", :password => "password123")
Game.create(:name => "The Tenth Plaguers", :max_difficulty => 3, :creator_id => yaniv.id)

wright = User.create(:user_name => "Wright", :email => "wright@email.com", :password => "password456")
Game.create(:name => "Operation Azorius", :max_difficulty => 3, :creator_id => wright.id)