require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "unpushed_commits" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }
    let(:gritrepo){ repo.send(:gritrepo) }

    # Reset the repository after each test
    after{ reset_git_repo_client }

    # Does the repository have unpushed commits?
    subject{ repo.unpushed_commits }

    context "on an in-sync repository" do
      it{
        should be_empty
      }
      specify{ repo.unpushed_commits?.should be_false }
    end

    context "on an non in-sync repository" do
      before {
        added = File.join(git_repo_client, "ADDED.md")
        File.open(added,"w"){|f| f << "content"}
        gritrepo.add(added)
        gritrepo.commit_all("New unpushed commit")
        File.open(added,"w"){|f| f << "content revisited"}
        gritrepo.commit_all("Set content to hello.txt")
      }
      specify{
        subject.should_not be_empty
        subject.map{|c| c.short_message}.should eq([
          "Set content to hello.txt",
          "New unpushed commit"
        ])
      }
      specify{ repo.unpushed_commits?.should be_true }
    end

  end
end

