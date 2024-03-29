require "spec_helper"
module WebSync
  describe ClientAgent, "unpushed_commits?" do

    let(:agent){ ClientAgent.new(wdir) }
    subject{ agent.unpushed_commits? }

    context "on a synchronized working dir" do
      let(:wdir){ Fixtures.a_synchronized_clone }
      it {
        should be_false
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
        should be_true
      }
    end

    context "on a forward and backwards clone" do
      let(:wdir){ Fixtures.a_forward_and_backwards_clone }
      it {
        should be_true
      }
    end

  end
end
