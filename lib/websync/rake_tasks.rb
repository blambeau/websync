require 'websync'
require 'rake'
require 'rake/dsl_definition'
module WebSync
  class RakeTasks < Agent
    include Rake::DSL

    attr_accessor :silent

    def initialize(namespace = "ws")
      @silent = false
      install_tasks(namespace)
      yield(self) if block_given?
    end

    def working_dir=(fs_dir)
      add_client_agent ClientAgent.new(fs_dir)
    end

    def add_client_agent(agent)
      listen(:save_request) do |ag,evt,message|
        safe("Saving your local version...") do
          agent.save(message)
        end
      end
      listen(:import_request) do |ag,evt|
        safe("Synchronizing your local version...") do
          agent.sync_local
        end
      end
      listen(:deploy_request) do |ag,evt|
        safe("Deploying your version -> production...") do
          agent.sync_repo
        end
      end
      agent.listen do |ag,evt,*args|
        signal(evt, *args)
      end
    end

    def safe(msg)
      $stdout << msg unless silent
      result = yield
      $stdout << " done!\n" unless silent
      result
    rescue Exception => ex
      $stdout << " failed.\n" unless silent
      $stderr << "Sorry, something goes wrong\n"
      $stderr << ex.message << "\n"
      $stderr << ex.backtrace.join("\n") << "\n"
      nil
    end

    private

      def install_tasks(namespace)
        namespace(namespace) do
          desc "Save the current website version"
          task(:save, :message){|t,args|
            signal(:save_request, args[:message]) 
          }
          desc "Import bug fixes and new features from the repository"
          task(:import){ 
            signal(:import_request)
          }
          desc "Deploy the web site on the production server"
          task(:deploy){ 
            signal(:deploy_request)
          }
        end
      end

  end # class ClientAgent
end # end WebSync
