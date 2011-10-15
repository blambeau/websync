require "spec_helper"
module WebSync
  describe ClientAgent, "pending_changes?" do

    let(:agent){ ClientAgent.new(wdir) }
    subject{ agent.pending_changes? }

    context "on a in-sync working dir" do
      let(:wdir){ Fixtures.an_in_sync_clone }
      it {
        should be_false
      }
    end

    context "on a modified working dir" do
      let(:wdir){ Fixtures.a_modified_clone }
      it {
        should be_true
      }
    end

    context "on a pure backwards clone" do
      let(:wdir){ Fixtures.a_backwards_clone }
      it {
        should be_false
      }
    end

    context "on a pure forward clone" do
      let(:wdir){ Fixtures.a_forward_clone }
      it {
        should be_false
      }
    end

  end
end
