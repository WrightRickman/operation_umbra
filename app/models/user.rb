class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :game_players
	has_many :player_missions
  has_many :games, through: :game_players
  has_many :missions, through: :player_missions
end
