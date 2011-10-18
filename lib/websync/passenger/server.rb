require 'sinatra/base'
module WebSync
  module Passenger
    #
    # Server-side agent for Passenger-oriented deployment.
    #
    class Server < Sinatra::Base

      # Create the server instance
      def initialize(wdir)
        super
        @working_dir = WorkingDir.coerce(wdir)
      end

      post '/' do
        @working_dir.rebase
        @working_dir.f_touch("tmp/restart.txt")
        "true"
      end

    end # class Server
  end # module Passenger
end # module WebSync
