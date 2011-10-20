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

    specify "save" do
      post '/user-request/save', {"message" => "Commit message"}
      last_response.should be_ok
      signals.should eq([[:"save-request", {"message" => "Commit message"}]])
    end

    specify "deploy" do
      post '/user-request/deploy'
      last_response.should be_ok
      signals.should eq([[:"deploy-request", {}]])
    end

  end
end
