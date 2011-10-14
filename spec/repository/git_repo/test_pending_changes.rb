require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "pending_changes?" do

    def build_clean_fixture_repo(working_dir)
      code = File.read(File.expand_path("../create_clean_repo", __FILE__))
      code = Kernel.eval("%Q{#{code}}", binding)
      `#{code}`
    end

    def reset_repo_changes(working_dir)
      `cd #{working_dir} && git reset --hard`
    end

    let(:working_dir){ File.join(fixtures_folder, "gitrepo") }
    let(:readme){ File.join(working_dir, "README.md") }
    let(:repo){ Repository::GitRepo.new(working_dir) }

    before(:all) {
      build_clean_fixture_repo(working_dir)
    }
    subject{ repo.pending_changes? }

    context "on a clean repository" do
      it{ should be_false }
    end

    context "on a repository with a changed file" do
      before{ 
        File.open(readme, "w"){|f| f << "new version"}
      }
      it{ 
        should be_true 
      }
      after{
        reset_repo_changes(working_dir)
      }
    end

  end
end

