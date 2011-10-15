require "spec_helper"
module WebSync
  describe ClientAgent, "sync_local" do

    let(:agent){ ClientAgent.new(wdir) }

    context "on an in-sync working dir" do
      let(:wdir){ Fixtures.an_in_sync_clone }
      specify {
        agent.sync_local.should be_false
      }
      after {
        agent.pending_changes?.should be_false
      }
    end

    context "on a working dir with pending changes" do
      let(:wdir){ Fixtures.a_modified_clone }
      specify {
        lambda {
          agent.sync_local
        }.should raise_error(Error)
      }
    end

    context "on a pure backwards clone" do
      let(:wdir){ Fixtures.a_backwards_clone! }
      specify {
        agent.sync_local.should be_true
      }
      after{
        agent.bug_fixes_available?.should be_false 
      }
    end

    context "on a pure forward and backwards clone" do
      let(:wdir){ Fixtures.a_forward_and_backwards_clone! }
      specify {
        agent.sync_local.should be_true
      }
      after{
        agent.bug_fixes_available?.should be_false 
        agent.unpushed_commits?.should be_true
      }
    end

  end
end
