require "spec_helper"
module WebSync
  describe ServerAgent, "synchronize" do

    let(:agent){ ServerAgent.new(wdir) }

    let(:events){ [] }
    before{ agent.listen{|ag,evt| events << [ag, evt]} }

    context "on an in-sync working dir" do
      let(:wdir){ Fixtures.an_in_sync_clone }
      specify {
        agent.synchronize.should be_false
      }
      after {
        agent.pending_changes?.should be_false
        events.should be_empty
      }
    end

    context "on a working dir with pending changes" do
      let(:wdir){ Fixtures.a_modified_clone }
      specify {
        lambda {
          agent.synchronize
        }.should raise_error(Error)
      }
    end

    context "on a pure backwards clone" do
      let(:wdir){ Fixtures.a_backwards_clone! }
      specify {
        agent.synchronize.should be_true
      }
      after{
        agent.production_up_to_date?.should be_true
        events.should eq([[agent, :production_up_to_date]])
      }
    end

  end
end
