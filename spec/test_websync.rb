require File.expand_path('../spec_helper', __FILE__)
describe WebSync do

  it "should have a version number" do
    WebSync.const_defined?(:VERSION).should be_true
  end

end
