require "spec_helper"
module WebSync
  describe Agent, "listen" do

    let(:agent){ Agent.new }

    context "when listen on all events with a block" do
      let(:seen){ [] }
      before{
        agent.listen do |agent,event|
          seen << [agent, event]
        end
      }
      specify{
        lambda{ 
          agent.send(:signal, :event0)
          agent.send(:signal, :event1)
        }.should_not raise_error
      }
      after {
        seen.size.should eq(2)
        seen.each_with_index do |pair, i|
          pair.first.should eq(agent)
          pair.last.should eq(:"event#{i}")
        end
      }
    end

  end
end
