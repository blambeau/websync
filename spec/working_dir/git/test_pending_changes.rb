require 'spec_helper'
module WebSync
  describe WorkingDir::Git, "pending_changes" do

    subject{ repo.pending_changes }

    context "on a clean working dir" do
      let(:repo){ Fixtures.an_in_sync_clone }
      specify {
        subject.should be_empty
        repo.has_pending_changes?.should be_false
      }
    end

    context "on a modified working dir" do
      let(:repo){ Fixtures.a_modified_clone }
      specify{
        Hash[repo.pending_changes.map{|c|
          [c.path, c.type || "TBA"]
        }].should eq({
          "README.md"  => "D",
          "ADDED.md"   => "TBA",
          ".gitignore" => "M"
        })
        repo.has_pending_changes?.should be_true
      }
    end

  end
end

