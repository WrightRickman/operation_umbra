class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :player_missions
end
