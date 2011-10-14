require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "pending_changes?" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }
    let(:readme){ File.join(git_repo_client, "README.md") }
    let(:added) { File.join(git_repo_client, "ADDED.md") }

    # Create a new repository before all tests
    before(:all) {
      build_clean_fixture_repo(working_dir)
    }

    # Reset the repository after each test
    after{
      reset_repo_changes(working_dir)
    }

    # Does the repository have pending changes?
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
    end

    context "on a repository with a file deleted" do
      before{ 
        FileUtils.rm(readme)
      }
      it{ 
        should be_true 
      }
    end

    context "on a repository with a file added" do
      before{ 
        File.open(added, "w"){|f| f << "file content"}
      }
      it{ 
        should be_true 
      }
    end

  end
end

