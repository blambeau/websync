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
        (subject/".gitignore").should exist
        subject.should be_synchronized
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
          (cl/".gitignore").should exist
          cl.should be_synchronized
        }
        seen.should be_true
      end
    end

  end
end
