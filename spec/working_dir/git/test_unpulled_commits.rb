require 'spec_helper'
module WebSync
  describe WorkingDir::Git, "unpulled_commits" do

    subject{ repo.unpulled_commits }

    context "on an synchronized repository" do
      let(:repo){ Fixtures.a_synchronized_clone }
      specify {
        subject.should be_empty
        repo.should_not be_backward
      }
    end

    context "on a backwards clone" do
      let(:repo){ Fixtures.a_backwards_clone }
      specify{
        subject.should_not be_empty
        subject.map{|c| c.short_message}.should eq([
          "A first bugfix"
        ])
        repo.should be_backward
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

