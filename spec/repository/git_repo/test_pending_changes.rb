require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "pending_changes?" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }
    let(:readme){ File.join(git_repo_client, "README.md") }
    let(:added) { File.join(git_repo_client, "ADDED.md") }

    subject{ repo.pending_changes? }

    context "on a clean repository" do
      it{
        should be_false
      }
    end

    context "on a repository with a file changed" do
      before{ 
        File.open(readme, "w"){|f| f << "new version"}
      }
      it{ 
        should be_true
      }
      after{ reset_git_repo_client }
    end

    context "on a repository with a file deleted" do
      before{ 
        FileUtils.rm(readme)
      }
      it{ 
        should be_true 
      }
      after{ reset_git_repo_client }
    end

    context "on a repository with a file added" do
      before{ 
        File.open(added, "w"){|f| f << "file content"}
      }
      it{ 
        should be_true 
      }
      after{ reset_git_repo_client }
    end

  end
end

