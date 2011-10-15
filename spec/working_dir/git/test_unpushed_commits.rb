require 'spec_helper'
module WebSync
  describe WorkingDir::Git, "unpushed_commits" do

    subject{ repo.unpushed_commits }

    context "on an in-sync working dir" do
      let(:repo){ Fixtures.an_in_sync_clone }
      specify {
        subject.should be_empty
        repo.has_unpushed_commits?.should be_false
      }
    end

    context "on a forward working dir" do
      let(:repo){ Fixtures.a_forward_clone }
      specify{
        subject.should_not be_empty
        subject.map{|c| c.short_message}.should eq([
          "And even more"
        ])
        repo.has_unpushed_commits?.should be_true
      }
      after{ reset_git_repo_client }
    end

  end
end

