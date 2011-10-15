require 'websync'
module WebSync
  class RakeTasks < Agent
    include Rake::DSL

    def initialize(namespace = "ws")
      install_tasks(namespace)
      yield(self)
    end

    def working_dir=(fs_dir)
      add_client_agent ClientAgent.new(fs_dir)
    end

    def add_client_agent(agent)
      listen(:save_request) do |ag,evt|
        agent.save
      end
      listen(:import_request) do |ag,evt|
        agent.sync_local
      end
      listen(:deploy_request) do |ag,evt|
        agent.sync_repo
      end
    end

    private

      def install_tasks(namespace)
        namespace(namespace) do
          desc "Save the current website version"
          task(:save){ 
            signal(:save_request) 
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
