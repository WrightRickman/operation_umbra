require 'spec_helper'

describe "Given two players," do
  before(:each) do
    @yaniv = create(:yaniv)
    @wright = create(:wright)
  end
  describe "if one started a game and the other joined," do
    before do
      @game = @yaniv.new_game("Test Game", 3, 3)
      @wright.join_game(@game)
    end
    describe "and the admin tried to start the game," do
      before do
        @game.start_game
      end
      it "the game should not have started" do
        expect(@game.started).to eq(false)
        expect(@game.rounds.length).to eq(0)
      end
    end
  end
end

describe "Given a game with three players," do
  before do
    @yaniv = create(:yaniv)
    @wright = create(:wright)
    @isaac = create(:isaac)
    @game = @yaniv.new_game("Test Game", 3, 3)
    @wright.join_game(@game)
    @isaac.join_game(@game)
  end
  describe "and the admin started the game," do
    before do
      create(:mission)
      @game.start_game
      @handlers = []
      @game.current_round.player_missions.each {|x| @handlers << x.handler}
      @handlers.uniq!
    end
    it "the game's started status should be true." do
      expect(@game.started).to eq(true)
    end
    it "the game should enter the first round." do
      expect(@game.rounds.length).to eq(1)
    end
    it "the players should all have missions." do
      expect(@yaniv.current_player.current_mission).to be_instance_of(PlayerMission)
      expect(@wright.current_player.current_mission).to be_instance_of(PlayerMission)
      expect(@isaac.current_player.current_mission).to be_instance_of(PlayerMission)
    end
    it "no player should be their own handler." do
      @yaniv.current_player.current_mission.handler.should_not eq(@yaniv)
      @wright.current_player.current_mission.handler.should_not eq(@wright)
      @isaac.current_player.current_mission.handler.should_not eq(@isaac)
    end
    it "each player should be a handler." do
      @handlers.length.should eq(3)
    end
    describe "and a handler accepted his agent's mission," do
      before(:each) do
        @yaniv.current_player.accept_mission
      end
      it "the round should not be over." do
        @game.current_round.round_end.should eq(nil)
      end
      it "the mission's success should be true." do
        PlayerMission.where(handler_id: @yaniv.current_player.id).last.success.should eq(true)
      end
    end
    describe "and a handler rejected his agent's mission," do
      before(:each) do
        @yaniv.current_player.reject_mission
      end
      it "the round should not be over." do
        @game.current_round.round_end.should eq(nil)
      end
      it "the mission's success should be false." do
        PlayerMission.where(handler_id: @yaniv.current_player.id).last.success.should eq(false)
      end
    end
    describe "and all handlers accepted their agent's mission," do
      before(:each) do
        create(:mission, description: "", assassination: true)
        create(:mission, description: "find bigger mailbox", level: 2)
        @game.current_round.force_end
      end
      it "the game should move to the next round." do
        @game.rounds.length.should == 2
      end
      describe "and given that all handlers accepted their agent's mission again," do
        before(:each) do
          create(:mission, description: "find an even bigger mailbox than that", level: 3)
          @game.current_round.force_end
        end
        it "there should only be two living players." do
          @game.living_players.length.should == 2
        end
        it "the game should be in the third round." do
          @game.rounds.length.should == 3
        end
        it "both remaining players should have the same mission." do
          @game.living_players.first.current_mission.mission.should == @game.living_players.last.current_mission.mission
        end
        it "both remaining players should have the same handler." do
          @game.living_players.first.current_mission.handler.should == @game.living_players.last.current_mission.handler
        end
        describe "and the handler accepts one of their missions," do
          before do
            @game.last_dead.accept_mission
            @game.reload
            @yaniv.reload
            @wright.reload
            @isaac.reload
          end
          it "the game's completed value should be true." do
            @game.completed.should be_true
          end
          it "only one player should still be alive." do
            @game.living_players.length.should == 1
          end
          it "all users should be unassigned from the game." do
            @yaniv.current_game.should == false
            @wright.current_game.should == false
            @isaac.current_game.should == false
          end
        end
      end
    end
  end
end