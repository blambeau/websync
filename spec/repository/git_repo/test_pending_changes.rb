require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "pending_changes?" do

    def build_clean_fixture_repo(working_dir)
      `rm -rf #{working_dir} &&
       mkdir #{working_dir}  &&
       cd #{working_dir}     &&
       git init              &&
       echo "initial commit" > README.md &&
       git add README.md &&
       git commit -a -m "Initial repository layout"`
    end

    def reset_repo_changes(working_dir)
      `cd #{working_dir} &&
       rm -rf ADDED.md   &&
       git reset --hard`
    end

    let(:working_dir){ File.join(fixtures_folder, "gitrepo") }
    let(:repo){ Repository::GitRepo.new(working_dir) }
    let(:readme){ File.join(working_dir, "README.md") }
    let(:added) { File.join(working_dir, "ADDED.md") }

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

