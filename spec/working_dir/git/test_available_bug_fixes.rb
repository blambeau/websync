require 'spec_helper'
module WebSync
  describe WorkingDir::Git, "available_bug_fixes" do

    subject{ repo.available_bug_fixes }

    context "on an in-sync repository" do
      let(:repo){ Fixtures.an_in_sync_clone }
      specify {
        subject.should be_empty
        repo.has_available_bug_fixes?.should be_false
      }
    end

    context "on a backwards clone" do
      let(:repo){ Fixtures.a_backwards_clone }
      specify{
        subject.should_not be_empty
        subject.map{|c| c.short_message}.should eq([
          "A first bugfix"
        ])
        repo.has_available_bug_fixes?.should be_true 
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

