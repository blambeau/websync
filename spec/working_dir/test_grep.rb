require 'spec_helper'
module WebSync
  describe WorkingDir, "grep" do

    it "should return the expected relation" do 
      wd = Fixtures.a_synchronized_clone
      wd.grep("ignored").to_a.should eq([
        {:file=>".gitignore", :line=>"1", :text=>"ignored.txt"}
      ])
    end

    it "should not be too sensible to ':'" do 
      wd = Fixtures.a_synchronized_clone
      wd.grep("git grep").to_a.should eq([
        {:file=>"README.md", :line=>"2", :text=>"This is a : line for testing : git grep"}
      ])
    end

    it "should not return raise error if nothing is found" do 
      wd = Fixtures.a_synchronized_clone
      wd.grep("nothing such can be found").to_a.should eq([])
    end

  end
end
