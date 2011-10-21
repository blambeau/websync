require 'spec_helper'
require 'websync/middleware'
require 'rack/test'
module WebSync
  describe Middleware, "/user-request/" do
    include Rack::Test::Methods

    def agent
      ag = Agent.new
      ag.listen{|ag,evt,args| signals << [evt, args]}
      ag
    end

    def app
      WebSync::Middleware.set :environment, :test
      WebSync::Middleware.set :agent, agent
      WebSync::Middleware.new
    end

    let(:signals){ [] }

    specify "save without summary" do
      post '/user-request/save', {}
      last_response.should_not be_ok
      last_response.status.should eq(400)
      last_response.body.should eq("Summary is mandatory")
    end

    specify "save" do
      post '/user-request/save', {"summary" => "Summary", 
                                  "description" => "* Description 1\n* Description 2"}
      last_response.should be_ok
      signals.should eq([[:"save-request", {"message" => "Summary\n\n* Description 1\n* Description 2\n"}]])
    end

    specify "deploy" do
      post '/user-request/deploy'
      last_response.should be_ok
      signals.should eq([[:"deploy-request", {}]])
    end

  end
end
