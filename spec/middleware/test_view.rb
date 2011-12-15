require 'spec_helper'
require 'websync/middleware'
require 'rack/test'
module WebSync
  describe Middleware, "/view/xxx" do
    include Rack::Test::Methods

    def app
      WebSync::Middleware.set :environment, :test
      WebSync::Middleware.set :agent, ClientAgent.new(wdir)
      WebSync::Middleware.new
    end

    after {
      last_response.should be_ok
    }

    context " / on a synchronized working dir / " do
      let(:wdir){ Fixtures.a_synchronized_clone }

      specify "import-admin" do
        get '/view/import-admin'
        last_response.body.should =~ /Nothing new in here/
      end

      specify "deploy-admin" do
        get '/view/deploy-admin'
        last_response.body.should =~ /Nothing to deploy for now/
      end

      specify "save-admin" do
        get '/view/save-admin'
        last_response.body.should =~ /Nothing to save for now/
      end

    end

    context " / on an dirty working dir / " do
      let(:wdir){ Fixtures.a_modified_clone }

      specify "import-admin" do
        get '/view/import-admin'
        last_response.body.should =~ /Nothing new in here/
      end

      specify "deploy-admin" do
        get '/view/deploy-admin'
        last_response.body.should =~ /Nothing to deploy for now/
      end

      specify "save-admin" do
        get '/view/save-admin'
        last_response.body.should =~ /The changes below can be saved at any time/
        last_response.body.should =~ /Files modified/
        last_response.body.should =~ /New files/
        last_response.body.should =~ /Missing files/
      end

    end

    context " / on an forward working dir / " do
      let(:wdir){ Fixtures.a_forward_clone }

      specify "import-admin" do
        get '/view/import-admin'
        last_response.body.should =~ /Nothing new in here/
      end

      specify "deploy-admin" do
        get '/view/deploy-admin'
        last_response.body.should =~ /Your production website may now be updated/
      end

      specify "save-admin" do
        get '/view/save-admin'
        last_response.body.should =~ /Nothing to save for now/
      end

    end

    context " / on an backward and forward working dir / " do
      let(:wdir){ Fixtures.a_forward_and_backwards_clone }

      specify "import-admin" do
        get '/view/import-admin'
        last_response.body.should =~ /A new version is available/
      end

      specify "deploy-admin" do
        get '/view/deploy-admin'
        last_response.body.should =~ /Unable to deploy. Import new updates first./
      end

      specify "save-admin" do
        get '/view/save-admin'
        last_response.body.should =~ /Nothing to save for now/
      end

    end

  end
end
