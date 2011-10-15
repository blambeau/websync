require 'spec_helper'
module WebSync
  describe Repository::Git, ".empty_dir?" do

    subject{ Repository::Git.empty_dir?(where) }

    context "on a non empty dir" do
      let(:where){ File.dirname(__FILE__) }
      it{ should be_false }
    end

    context "on a non existing dir" do
      let(:where){ File.join(File.dirname(__FILE__), "non-existing") }
      it{ should be_true }
    end

    context "on an empty dir" do
      let(:where){ Dir.mktmpdir }
      it{ should be_true }
    end

  end
end
