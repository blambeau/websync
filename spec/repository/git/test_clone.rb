require 'spec_helper'
module WebSync
  describe Repository::Git, "#clone" do

    let(:origin){ Fixtures.the_bare_repository }

    context "on a non-existing directory" do
      subject{ origin.clone(where) }
      let(:where){ 
        Dir.mktmpdir("websync_test_clone_existing") 
      }
      before{ 
        FileUtils.rm_rf(where) 
      }
      specify{
        subject.should be_a(WorkingDir)
        subject.exists?(".gitignore").should be_true
        subject.in_sync?.should be_true
      }
    end

    context "on an existing directory" do
      subject{ origin.clone(where) }
      let(:where){ File.dirname(__FILE__) }
      specify{
        lambda{ subject }.should raise_error(ArgumentError)
      }
    end

    specify "with a block" do
      Dir.mktmpdir do |where|
        seen = false
        origin.clone(where){|cl| 
          seen = true
          cl.should be_a(WorkingDir)
          cl.exists?(".gitignore").should be_true
          cl.in_sync?.should be_true
        }
        seen.should be_true
      end
    end

  end
end
