require 'spec_helper'

describe "Given an open game and a user," do
  before :each do
    @game = create(:game)
    @yaniv = create(:yaniv)
  end
  describe "and the user joins the game," do
    before do
      @yaniv.join_game(@game)
    end
    it "the user's current game should be the game joined." do
      expect(@yaniv.current_game).to eq(@game)
    end
    it "the user should have a current player." do
      expect(@yaniv.current_player).to be_instance_of(GamePlayer)
    end
    describe "and the user then leaves the game," do
      before do
        @yaniv.leave_game
      end
      it "the user should have no current game" do
        expect(@yaniv.current_game).to eq(nil)
      end
    end


  end

end
