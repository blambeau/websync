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
          agent.signal(:event0)
          agent.signal(:event1)
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

    context "when passed a callable" do
      let(:fired){ [] }
      let(:callable){ Proc.new{ fired << true } }
      before{ 
        agent.listen(:event, callable) 
      }
      specify{
        lambda{ agent.signal(:event) }.should_not raise_error
      }
      after{
        fired.should eq([true])
      }
    end

  end
end
