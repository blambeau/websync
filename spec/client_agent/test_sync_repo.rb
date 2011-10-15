require "spec_helper"
module WebSync
  describe ClientAgent, "sync_repo" do

    let(:agent){ ClientAgent.new(wdir) }

    let(:events){ [] }
    before{ agent.listen{|ag,evt| events << [ag, evt]} }

    context "on an in-sync working dir" do
      let(:wdir){ Fixtures.an_in_sync_clone }
      specify {
        agent.sync_repo.should be_false
      }
      after {
        agent.pending_changes?.should be_false
        agent.unpushed_commits?.should be_false
        agent.bug_fixes_available?.should be_false
        events.should be_empty
      }
    end

    context "on a working dir with pending changes" do
      let(:wdir){ Fixtures.a_modified_clone }
      specify {
        lambda {
          agent.sync_repo
        }.should raise_error(Error)
      }
    end

    context "on a pure backwards clone" do
      let(:wdir){ Fixtures.a_backwards_clone! }
      specify {
        lambda {
          agent.sync_repo
        }.should raise_error(Error)
      }
    end

    context "on a pure foward clone" do
      let(:wdir){ Fixtures.a_forward_clone! }
      specify {
        agent.sync_repo.should be_true
      }
      after {
        agent.pending_changes?.should be_false
        agent.unpushed_commits?.should be_false
        agent.bug_fixes_available?.should be_false
        events.should eq([[agent, :repository_synchronized]])
      }
    end

    context "on a pure forward and backwards clone" do
      let(:wdir){ Fixtures.a_forward_and_backwards_clone! }
      specify {
        lambda {
          agent.sync_repo
        }.should raise_error(Error)
      }
    end

  end
end
