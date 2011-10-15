require 'spec_helper'
module WebSync
  describe Repository::Git, "#clone" do

    before(:all){ 
      FileUtils.rm_rf(origin = Dir.mktmpdir("origin"))
      @origin = Repository::Git.create(origin)
    }

    subject{ 
      @origin.clone(where) 
    }

    context "on a non-existing directory" do
      let(:where){ Dir.mktmpdir }
      before{ FileUtils.rm_rf(where) }
      specify{
        subject.should be_a(WorkingDir)
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
end
