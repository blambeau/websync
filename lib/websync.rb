require "websync/version"
require "fileutils"
require "grit"
#
# End-user oriented website synchronization
#
module WebSync

  autoload :Passenger, "websync/passenger"
end # module WebSync
require 'websync/errors'
require 'websync/repository'
require 'websync/working_dir'
require 'websync/agent'
require 'websync/client_agent'
require 'websync/server_agent'
