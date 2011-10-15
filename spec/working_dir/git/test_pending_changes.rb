require 'spec_helper'
module WebSync
  describe WorkingDir::Git, "pending_changes" do

    let(:repo){ WorkingDir::Git.new(git_repo_client) }
    let(:readme){ File.join(git_repo_client, "README.md") }
    let(:added) { File.join(git_repo_client, "ADDED.md") }

    subject{ repo.pending_changes }

    context "on a clean repository" do
      specify{
        repo.pending_changes.should be_empty
        repo.has_pending_changes?.should be_false
      }
    end

    context "on a repository with a file changed" do
      before{ 
        File.open(readme, "w"){|f| f << "new version"}
      }
      it{
        changes = repo.pending_changes
        changes.size.should eq(1)
        changes.all?{|c| c.type == "M"}
        repo.has_pending_changes?.should be_true
      }
      after{ reset_git_repo_client }
    end

    context "on a repository with a file deleted" do
      before{ 
        FileUtils.rm(readme)
      }
      it{ 
        changes = repo.pending_changes
        changes.size.should eq(1)
        changes.all?{|c| c.type == "D"}
        repo.has_pending_changes?.should be_true
      }
      after{ reset_git_repo_client }
    end

    context "on a repository with a file added" do
      before{ 
        File.open(added, "w"){|f| f << "file content"}
      }
      it{ 
        changes = repo.pending_changes
        changes.size.should eq(1)
        changes.all?{|c| c.untracked}
        repo.has_pending_changes?.should be_true
      }
      after{ reset_git_repo_client }
    end

  end
end

