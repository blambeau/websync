require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "bug_fixes_available" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }
    let(:gritrepo){ repo.send(:gritrepo) }

    subject{ repo.bug_fixes_available }

    context "on an in-sync repository" do
      it{
        should be_empty
      }
      specify{ repo.bug_fixes_available?.should be_false }
    end

    context "on an non in-sync repository" do
      before {
        previous = gritrepo.commit('HEAD').id
        added = File.join(git_repo_client, "ADDED.md")
        FileUtils.touch(added)
        gritrepo.add(added)
        gritrepo.commit_all("New unpulled bugfix")
        gritrepo.git.push({}, 'origin', 'master')
        gritrepo.git.reset({:hard => true}, previous)
      }
      specify{
        subject.should_not be_empty
        subject.map{|c| c.short_message}.should eq([
          "New unpulled bugfix"
        ])
        repo.bug_fixes_available?.should be_true 
      }
      after{ reset_git_repo_client }
    end

  end
end

