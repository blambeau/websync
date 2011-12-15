require 'spec_helper'
module WebSync
  describe WorkingDir, "/" do

    it "should return the expected path" do 
      wd = WorkingDir.new(File.dirname(__FILE__))
      (wd/"test_division.rb").should be_a(Path)
      (wd/"test_division.rb").should eq(Path(__FILE__))
    end

  end
end
