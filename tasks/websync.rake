desc %q{Launches websync on a given repository}
task :websync, :where do |t, args|
  root = File.expand_path('../..', __FILE__)
  $LOAD_PATH.unshift File.join(root, 'lib')
  $LOAD_PATH.unshift File.join(root, 'spec')
  require 'spec_helper'
  require 'websync/middleware'
  require 'websync/client_agent'
  clone = WebSync::Fixtures.send(args[:where])
  WebSync::Middleware.set :agent, WebSync::ClientAgent.new(clone)
  WebSync::Middleware.run!
end
