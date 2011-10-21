require 'websync'
require 'wlang'
require 'sinatra/base'
module WebSync
  class Middleware < Sinatra::Base

    # PUBLIC of the web application
    PUBLIC = File.expand_path('../middleware/public', __FILE__)

    # Resolves `file` from the public folder
    def self._(file)
      File.join(PUBLIC, file)
    end

    ############################################################## Configuration
    # Serve public pages from public
    set :public_folder, PUBLIC

    ############################################################## Get routes

    get '/' do
      serve 'index.wtpl'
    end

    get '/view/:name' do 
      serve "views/#{params[:name]}.wtpl"
    end

    ############################################################## Post actions

    post '/user-request/import' do
      settings.agent.signal(:"import-request", params)
      true
    end

    post '/user-request/save' do
      settings.agent.signal(:"save-request", params)
      true
    end

    post '/user-request/deploy' do
      settings.agent.signal(:"deploy-request", params)
      true
    end

    ############################################################## Error handling

    # error handling
    error do
      'Sorry, an error occurred'
    end

    ############################################################## Helpers

    # Serves a given wlang file
    def serve(file)
      tpl  = _(file)
      ctx  = {
        :model => Model.new(settings.agent),
        :environment => settings.environment,
      }
      WLang::file_instantiate tpl, ctx
    end

    # Resolves `file` from the public folder
    def _(file)
      self.class._(file)
    end

  end # class Middleware
end # module WebSycn
require 'websync/middleware/model'
