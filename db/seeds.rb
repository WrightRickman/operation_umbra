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
wright = User.create(:user_name => "Wright", :email => "wright@email.com", :password => "password456", :phone_number => "5166552432", :current_game => this_game.id)
bushkanets = User.create(:user_name => "Danny", :email => "danny@email.com", :password => "password123", :phone_number => "5551234567", :current_game => this_game.id)
princess_pretzel = User.create(:user_name => "Brittany", :email => "brittany@email.com", :password => "password123", :phone_number => "5552345678", :current_game => this_game.id)
GamePlayer.create(:user_id => yaniv.id, :game_id => this_game.id)
GamePlayer.create(:user_id => wright.id, :game_id => this_game.id)
GamePlayer.create(:user_id => bushkanets.id, :game_id => this_game.id)
GamePlayer.create(:user_id => princess_pretzel.id, :game_id => this_game.id)

#======== Missions ==========

#Level 1: 0-2 minutes
Mission.create(:description => "Find a mailbox.", :level => 1)
Mission.create(:description => "Find a water bottle.", :level => 1)
Mission.create(:description => "Find a coffee cup.", :level => 1)
Mission.create(:description => "Find a tree.", :level => 1)
Mission.create(:description => "Find a bush.", :level => 1)
Mission.create(:description => "Find a flower.", :level => 1)
Mission.create(:description => "High five your handler.", :level => 1)
Mission.create(:description => "Find a poster for a band.", :level => 1)
Mission.create(:description => "Find a poster for a film.", :level => 1)
Mission.create(:description => "Find a poster for a television show.", :level => 1)
Mission.create(:description => "Find a lamp post.", :level => 1)
Mission.create(:description => "Find a telephone pole.", :level => 1)
Mission.create(:description => "Find a door.", :level => 1)
Mission.create(:description => "Find a person wearing black.", :level => 1)
Mission.create(:description => "Find a person wearing white.", :level => 1)
Mission.create(:description => "Teach your handler a secret handshake.", :level => 1)
Mission.create(:description => "Find a bike.", :level => 1)
Mission.create(:description => "Find a coin older than you are.", :level => 1)
Mission.create(:description => "Find a coin younger than you are.", :level => 1)
Mission.create(:description => "Find a take-out menu.", :level => 1)
Mission.create(:description => "Find a car.", :level => 1)
Mission.create(:description => "Find a toy.", :level => 1)
Mission.create(:description => "Find something that begins with the letter A.", :level => 1)
Mission.create(:description => "Find something that begins with the letter B.", :level => 1)
Mission.create(:description => "Find something that begins with the letter C.", :level => 1)
Mission.create(:description => "Find something that begins with the letter D.", :level => 1)
Mission.create(:description => "Find something that begins with the letter E.", :level => 1)
Mission.create(:description => "Find something that begins with the letter F.", :level => 1)
Mission.create(:description => "Find something that begins with the letter G.", :level => 1)
Mission.create(:description => "Find something that begins with the letter H.", :level => 1)
Mission.create(:description => "Find something that begins with the letter I.", :level => 1)
Mission.create(:description => "Find something that begins with the letter J.", :level => 1)
Mission.create(:description => "Find something that begins with the letter K.", :level => 1)
Mission.create(:description => "Find something that begins with the letter L.", :level => 1)
Mission.create(:description => "Find something that begins with the letter M.", :level => 1)
Mission.create(:description => "Find something that begins with the letter N.", :level => 1)
Mission.create(:description => "Find something that begins with the letter O.", :level => 1)
Mission.create(:description => "Find something that begins with the letter P.", :level => 1)
Mission.create(:description => "Find something that begins with the letter R.", :level => 1)
Mission.create(:description => "Find something that begins with the letter S.", :level => 1)
Mission.create(:description => "Find something that begins with the letter T.", :level => 1)
Mission.create(:description => "Find something that begins with the letter U.", :level => 1)
Mission.create(:description => "Find something that begins with the letter W.", :level => 1)
Mission.create(:description => "Find a person in a necktie.", :level => 1)
Mission.create(:description => "Find a person in sunglasses.", :level => 1)
Mission.create(:description => "Find a book.", :level => 1)
Mission.create(:description => "Find a magazine.", :level => 1)
Mission.create(:description => "Throw a penny in a fountain.", :level => 1)

#Level 2: 2-10 minutes
Mission.create(:description => "Find a person wearing blue.", :level => 2)
Mission.create(:description => "Find a person wearing red.", :level => 2)
Mission.create(:description => "Find a person wearing green.", :level => 2)
Mission.create(:description => "Find a person wearing yellow.", :level => 2)
Mission.create(:description => "Find a person wearing orange.", :level => 2)
Mission.create(:description => "Meet a new dog.", :level => 2)
Mission.create(:description => "Find an enemy operative (aka any person in a suit).", :level => 2)
Mission.create(:description => "Find a recipt.", :level => 2)
Mission.create(:description => "Do a handstand in front of your handler.", :level => 2)
Mission.create(:description => "Do ten pushups in front of your handler.", :level => 2)
Mission.create(:description => "Do fifteen jumping jacks in front of your handler.", :level => 2)
Mission.create(:description => "Capitulate to authority (tell a public offical they are doing a bang-up job).", :level => 2)
Mission.create(:description => "High five a stranger in front of your handler.", :level => 2)
Mission.create(:description => "Adopt a foreign accent. Introduce yourself to a stranger.", :level => 2)
Mission.create(:description => "Find an egg.", :level => 2)
Mission.create(:description => "Find a Metrocard, bus pass, or train ticket.", :level => 2)
Mission.create(:description => "Find a coin from the year you were born.", :level => 2)
Mission.create(:description => "Acquire a business card from a stranger.", :level => 2)
Mission.create(:description => "Acquire a stranger's signature.", :level => 2)
Mission.create(:description => "Find something glow-in-the-dark.", :level => 2)
Mission.create(:description => "Find something Canadian.", :level => 1)
Mission.create(:description => "Find something that begins with the letter Q.", :level => 1)
Mission.create(:description => "Find something that begins with the letter V.", :level => 1)
Mission.create(:description => "Find something that begins with the letter X.", :level => 1)
Mission.create(:description => "Find something that begins with the letter Y.", :level => 1)
Mission.create(:description => "Find something that begins with the letter Z.", :level => 1)
Mission.create(:description => "Find a tattoo (that isn't yours).", :level => 1)
Mission.create(:description => "Find a sculpture.", :level => 2)
Mission.create(:description => "Find a revolving door.", :level => 2)
Mission.create(:description => "Find obsolete technology.", :level => 2)
Mission.create(:description => "Find a poster for a film no longer in theaters.", :level => 2)
Mission.create(:description => "Find chopsticks.", :level => 2)
Mission.create(:description => "Find a scooter.", :level => 2)
Mission.create(:description => "Bring your handler a hot dog.", :level => 2)
Mission.create(:description => "Find a pamphlet.", :level => 2)
Mission.create(:description => "Hug a stranger.", :level => 2)
Mission.create(:description => "'WHAT YEAR IS IT!? WHO IS THE PRESIDENT!? Convince a stranger you have travelled through time.", :level => 2)
Mission.create(:description => "Feed a pigeon.", :level => 2)

#Level 3: 10-30 minutes
Mission.create(:description => "Find a reciept for $2 or less.", :level => 3)
Mission.create(:description => "Find a reciept for $30 or more.", :level => 3)
Mission.create(:description => "Find a movie ticket.", :level => 3)
Mission.create(:description => "Find a misspelled sign.", :level => 3)
Mission.create(:description => "Intercept a missive (have a stranger write a short note for your handler).", :level => 3)
Mission.create(:description => "Find a squirrel.", :level => 3)
Mission.create(:description => "Convince your handler that the system is broken and you did not receive a mission.", :level => 3)
Mission.create(:description => "Convince a stranger to tell a joke.", :level => 3)
Mission.create(:description => "Write a coded message using a cipher.", :level => 3)
Mission.create(:description => "Hide a secret message in a book.", :level => 3)
Mission.create(:description => "Find a memorial.", :level => 3)
Mission.create(:description => "Find a person in a bow tie.", :level => 3)
Mission.create(:description => "Find a pay phone that still works.", :level => 3)
Mission.create(:description => "Find foreign currency.", :level => 3)
Mission.create(:description => "Find a poster that isn't in English.", :level => 3)
Mission.create(:description => "Find a poster for a foreign film.", :level => 3)
Mission.create(:description => "Find a statue of a horse.", :level => 3)
Mission.create(:description => "Feed a pigeon off of your own body.", :level => 3)

#Level 4: 30 minutes - 1.5 hours
Mission.create(:description => "Sing with a street performer.", :level => 4)
Mission.create(:description => "Learn and perform a magic trick.", :level => 4)
Mission.create(:description => "Find a rainbow.", :level => 4)
Mission.create(:description => "Find a celebrity.", :level => 4)
Mission.create(:description => "Find a statue of a horse with two legs up.", :level => 4)

#Level 5: 1.5 - 4 hours
Mission.create(:description => "Go to the nearest movie theater. Watch the film beginning closest to now.", :level => 5)
Mission.create(:description => "Play a game of chess.", :level => 5)

#Level 6: 4-12 hours
Mission.create(:description => "Invent a new game. Get all players to play your game within this game.", :level => 6)

#Level 7: 12-24 hours
Mission.create(:description => "Take a photo with an actual celebrity.", :level => 7)

















=======
Mission.create(:description => "Find a mailbox", :level => 1)
Mission.create(:description => "Find a water bottle", :level => 1)
Mission.create(:description => "Find a tree", :level => 1)
Mission.create(:description => "High five a stranger in front of your handler", level: 1)
Mission.create(:description => "Hug a stranger", :level => 2)
Mission.create(:description => "Find a person wearing red", :level => 2)
Mission.create(:description => "Find a receipt for $2 or less", :level => 2)
Mission.create(:description => "Assassinate your target", :level => 10)
>>>>>>> f3ec4e247490714f72c9f67791cfe52995cd8550
