require 'spec_helper'
module WebSync

  describe Fixtures, "the_bare_repository" do
    subject{ Fixtures.the_bare_repository }

    it {
      should be_kind_of(Repository)
    }

  end

  describe Fixtures, "an in-sync clone" do
    subject{ Fixtures.an_in_sync_clone }

    it {
      should be_kind_of(WorkingDir)
    }

    specify("it should have expected files") {
      subject.exists?(".gitignore").should be_true
      subject.exists?("README.md").should be_true
      subject.exists?("ignored.txt").should be_false
    }

    specify("files should have expected content") {
      subject.f_read(".gitignore").should eq("ignored.txt\n")
    }

  end

end
