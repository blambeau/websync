require 'spec_helper'
require 'websync/rake_tasks'
module WebSync
  describe RakeTasks do

    let(:folder){ File.expand_path("../rake_tasks",__FILE__) }

    specify "ws:save" do
      Dir.chdir(folder) do
        `rake ws:save["Hello World!"]`.should eq("Saved: Hello World!\n")
      end
    end

    specify "ws:import" do
      Dir.chdir(folder) do
        `rake ws:import`.should eq("Working dir synchronized\n")
      end
    end

    specify "ws:deploy" do
      Dir.chdir(folder) do
        `rake ws:deploy`.should eq("Repository synchronized\n")
      end
    end

  end
end
