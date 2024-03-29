require "spec_helper"
module WebSync
  describe ServerAgent, "pending_changes?" do

    let(:agent){ ServerAgent.new(wdir) }
    subject{ agent.pending_changes? }

    context "on a synchronized working dir" do
      let(:wdir){ Fixtures.a_synchronized_clone }
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
