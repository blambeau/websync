require 'spec_helper'
module WebSync
  describe WorkingDir::Git, "pending_changes" do

    subject{ repo.pending_changes }

    context "on a clean working dir" do
      let(:repo){ Fixtures.a_synchronized_clone }
      specify {
        subject.should be_empty
        repo.should be_clean
        repo.should_not be_dirty
      }
    end

    context "on a modified working dir" do
      let(:repo){ Fixtures.a_modified_clone }
      specify{
        Hash[repo.pending_changes.map{|c|
          [c.path, c.type]
        }].should eq({
          "README.md"  => "D",
          "ADDED.md"   => nil,
          ".gitignore" => "M"
        })
        repo.should be_dirty
        repo.should_not be_clean
      }
    end

    context "on a corrupted repository" do
      let(:repo){ Fixtures.a_corrupted_clone }
      specify{ 
        lambda{ subject }.should raise_error(Grit::InvalidGitRepositoryError)
      }
    end

  end
end

