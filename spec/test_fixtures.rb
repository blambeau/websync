require 'spec_helper'
module WebSync
  describe Fixtures, "the_bare_repository" do

    subject{ Fixtures.the_bare_repository }

    it{ should be_kind_of(Repository) }

  end
end
