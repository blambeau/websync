require 'spec_helper'
module WebSync
  describe Repository::Git, "create" do

    subject{ Repository::Git.create(where) }

    context "on a non-existing directory" do
      let(:where){ Dir.mktmpdir }
      before{ FileUtils.rm_rf(where) }
      specify{
        subject.should be_a(Repository)
        File.directory?(File.join(where, "info")).should be_true
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
