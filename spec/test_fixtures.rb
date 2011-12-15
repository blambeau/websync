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
      (subject/".gitignore").should exist
      (subject/"README.md").should exist
      (subject/"ignored.txt").should_not exist
    }

    specify("files should have expected content") {
      (subject/".gitignore").read.should eq("ignored.txt\ntmp\n")
    }

  end

end
