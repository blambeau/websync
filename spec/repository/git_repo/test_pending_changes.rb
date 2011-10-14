require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "pending_changes?" do

    def build_clean_fixture_repo(working_dir)
      code = File.read(File.expand_path("../create_clean_repo", __FILE__))
      code = Kernel.eval("%Q{#{code}}", binding)
      `#{code}`
    end

    let(:working_dir){ File.join(fixtures_folder, "gitrepo") }
    let(:repo){ Repository::GitRepo.new(working_dir) }

    before(:all) {
      build_clean_fixture_repo(working_dir)
    }
    subject{ repo.pending_changes? }

    context "on a clean repository" do
      it{ should be_false }
    end

  end
end

