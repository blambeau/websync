require "spec_helper"
module WebSync
  describe ClientAgent, "save" do

    let(:agent){ ClientAgent.new(wdir) }

    context "on a working dir without pending changes" do
      let(:wdir){ Fixtures.an_in_sync_clone }
      specify {
        lambda {
          agent.save("message")
        }.should_not raise_error
      }
      after {
        agent.pending_changes?.should be_false
      }
    end

    context "on a working dir with pending changes" do
      let(:wdir){ Fixtures.a_modified_clone! }
      specify {
        lambda {
          agent.save("message")
        }.should_not raise_error
      }
      after {
        agent.pending_changes?.should be_false
      }
    end

  end
end
