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
    disable :raise_errors
    disable :show_exceptions

    ############################################################## Get routes

    get '/' do
      #settings.agent.refresh
      serve 'index.wtpl'
    end

    get '/view/:name' do 
      serve "views/#{params[:name]}.wtpl"
    end

    ######################################################### Search and replace

    get "/search" do
      results = wd.grep(params["expression"], {
        :I => true,
        :ignore_case => true,
        :word_regexp => true
      })
      if results.empty?
        [404, {"Content-Type" => "text/plain"}, "No result found."]
      else
        serve "views/search-results.wtpl", {:results => results}
      end
    end

    ######################################################### Search and replace

    get "/ace/get-file" do
      path = params["file"]
      if (wd/path).exist?
        send_file (wd/path).to_s
      else
        not_found
      end
    end

    post "/ace/save" do
      path = params["file"]
      (wd/path).write(params["value"])
      send_file (wd/path).to_s
    end

    ############################################################## Post actions

    post '/user-request/import' do
      settings.agent.signal(:"import-request", params)
      true
    end

    post '/user-request/save' do
      # clean arguments
      summary = (params["summary"] || "").strip
      description = (params["description"] || "").strip

      # check them
      raise ValidationError, "Summary is mandatory" if summary.empty?

      # send message
      message = summary + "\n\n" + description + "\n"
      settings.agent.signal(:"save-request", {"message" => message})
      true
    end

    post '/user-request/deploy' do
      settings.agent.signal(:"deploy-request", params)
      true
    end

    ############################################################## Error handling

    # error handling
    error do
      content_type "text/plain"
      case err = env['sinatra.error']
      when WebSync::ValidationError
        [ 400, 
          {"Content-type" => "text/plain"}, 
          [ err.message ] ]
      else
        [ 500, 
          {"Content-type" => "text/plain"}, 
          ["Sorry, an unexpected error occured: #{err.message}\n" + 
           err.backtrace.join("\n")] ]
      end
    end

    ############################################################## Helpers

    def wd
      settings.agent.working_dir
    end

    # Serves a given wlang file
    def serve(file, ctx = {})
      tpl  = _(file)
      ctx  = ctx.merge({
        :model => Model.new(settings.agent),
        :environment => settings.environment,
      })
      WLang::file_instantiate tpl, ctx
    end

    # Resolves `file` from the public folder
    def _(file)
      self.class._(file)
    end

  end # class Middleware
end # module WebSycn
require 'websync/middleware/model'
