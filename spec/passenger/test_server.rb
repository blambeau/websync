require 'spec_helper'
require 'rack/test'
module WebSync
  describe Passenger::Server do
    include Rack::Test::Methods

    let(:app) { Passenger::Server.new(wdir) }

#    context "the synchronization mechanism" do
#      let(:wdir){ Fixtures.a_backwards_clone! }
#      before { 
#        wdir.in_sync?.should be_false
#      }
#      specify {
#        post '/'
#        last_response.status.should eq(200)
#      }
#      after { 
#        wdir.in_sync?.should be_true
#      }
#    end

#    context "restart.txt" do
#      let(:wdir){ Fixtures.an_in_sync_clone   }
#      before { 
#        wdir.f_delete("tmp/restart.txt") 
#        wdir.f_exists?("tmp/restart.txt").should be_false
#      }
#      specify {
#        post '/'
#        last_response.status.should eq(200)
#      }
#      after {
#        wdir.f_exists?("tmp/restart.txt").should be_true
#      }
#    end

  end
end

