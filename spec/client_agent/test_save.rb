require "spec_helper"
module WebSync
  describe ClientAgent, "save" do

    let(:agent) { ClientAgent.new(wdir) }

    let(:events){ [] }
    before{ agent.listen{|ag,evt| events << [ag, evt]} }

    context "on a working dir without pending changes" do
      let(:wdir){ Fixtures.a_synchronized_clone }
      before {
        agent.may_save?.should be_false
      }
      specify {
        agent.save("message").should be_false
      }
      after {
        agent.pending_changes?.should be_false
        events.should be_empty
      }
    end

    context "on a working dir with pending changes" do
      let(:wdir){ Fixtures.a_modified_clone! }
      before {
        agent.may_save?.should be_true
      }
      specify {
        agent.save("message").should be_true
      }
      after {
        agent.pending_changes?.should be_false
        events.should eq([[agent, :working_dir_saved]])
      }
    end

  end
end
