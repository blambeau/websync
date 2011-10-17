require 'spec_helper'
require 'websync/rake_tasks'
module WebSync
  describe RakeTasks do

    let(:folder){ File.dirname(__FILE__) }

    subject{ 
      Dir.chdir(folder) do
        `rake #{task}`
      end
    }

    describe "ws:save" do
      let(:task){ 'ws:save["Hello World!"]' }
      it{ should eq("Saved: Hello World!\n") }
    end

    describe "ws:import" do
      let(:task){ 'ws:import' }
      it { should eq("Working dir synchronized\n") }
    end

    describe "ws:deploy" do
      let(:task){ 'ws:deploy' }
      it { should eq("Repository synchronized\n") }
    end

  end
end
