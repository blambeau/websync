require "spec_helper"
module WebSync
  describe ServerAgent, "production_up_to_date?" do

    let(:agent){ ServerAgent.new(wdir) }
    subject{ agent.production_up_to_date? }

    context "on a in-sync working dir" do
      let(:wdir){ Fixtures.an_in_sync_clone }
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

  end
end
