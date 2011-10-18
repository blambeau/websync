module WebSync
  describe WorkingDir, "sh" do

    let(:fs_dir){ File.dirname(__FILE__) }
    let(:wdir)  { WorkingDir.new(fs_dir) }

    subject{ wdir.sh("ls test_sh.rb") }

    specify {
      subject.split("\n").should eq(["test_sh.rb"])
    }

  end
end
