require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "available_bug_fixes" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }
    let(:gritrepo){ repo.send(:gritrepo) }

    subject{ repo.available_bug_fixes }

    context "on an in-sync repository" do
      it{
        should be_empty
      }
      specify{ repo.has_available_bug_fixes?.should be_false }
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
        repo.has_available_bug_fixes?.should be_true 
      }
      after{ reset_git_repo_client }
    end

  end
end

