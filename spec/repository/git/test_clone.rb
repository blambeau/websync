require 'spec_helper'
module WebSync
  describe Repository::Git, "#clone" do

    before(:all){ 
      FileUtils.rm_rf(origin = Dir.mktmpdir("websync_test_clone_origin"))
      @origin = Repository::Git.create(origin)
    }

    context "without a block" do

      subject{ @origin.clone(where) }

      context "on a non-existing directory" do
        let(:where){ Dir.mktmpdir("websync_test_clone_existing") }
        before{ FileUtils.rm_rf(where) }
        specify{
          subject.should be_a(WorkingDir)
          subject.exists?(".gitignore").should be_true
          subject.in_sync?.should be_true
        }
      end

      context "on an existing directory" do
        let(:where){ File.dirname(__FILE__) }
        specify{
          lambda{ subject }.should raise_error(ArgumentError)
        }
      end

    end

    context "with a block" do
      let(:where){ Dir.mktmpdir }
      before{ FileUtils.rm_rf(where) }
      specify{
        seen = nil
        @origin.clone(where){|cl| seen = cl}
        seen.should be_a(WorkingDir)
        seen.exists?(".gitignore").should be_true
        seen.in_sync?.should be_true
      }
    end

  end
end
