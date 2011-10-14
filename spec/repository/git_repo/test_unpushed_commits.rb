require 'spec_helper'
module WebSync
  describe Repository::GitRepo, "unpushed_commits?" do

    let(:repo){ Repository::GitRepo.new(git_repo_client) }

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

