module WebSync
  module Passenger
    #
    # Server-side agent for Passenger-oriented deployment.
    #
    class Server

      # Create the server instance
      def initialize(wdir)
        @working_dir = WorkingDir.coerce(wdir)
      end

      def call(env)
        if env["REQUEST_METHOD"] == "POST"
          @working_dir.rebase
          @working_dir.f_touch("tmp/restart.txt")
          [200, {"Content-Type" => "text/plain"}, ["Ok"]]
        else
          [404, {"Content-Type" => "text/plain"}, ["Not found"]]
        end
      end

    end # class Server
  end # module Passenger
end # module WebSync
