require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "unpushed_commits?" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }

    # Create a new repository before all tests
    before(:all) { build_git_repo }

    # Reset the repository after each test
    after{ reset_git_repo_client }

    # Does the repository have unpushed commits?
    subject{ repo.unpushed_commits? }

    context "on an in-sync repository" do
      it{
        should be_false
      }
    end

  end
end

