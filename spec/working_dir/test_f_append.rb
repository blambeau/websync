module WebSync
  describe WorkingDir, "f_write" do

    let(:fs_dir){ File.dirname(__FILE__) }
    let(:wdir)  { WorkingDir.new(fs_dir) }
    let(:path){ "a-new-file.txt" }
    let(:exp_path){ File.expand_path("../#{path}", __FILE__) }

    subject{ wdir.f_append(path, "second\n") }

    before{ 
      File.open(exp_path, "w"){|f| f << "first\n"}
    }
    specify {
      subject.should_not be_nil
      File.read(exp_path).should eq("first\nsecond\n")
    }
    after{ 
      FileUtils.rm_rf(exp_path) 
    }

  end
end
