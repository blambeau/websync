module WebSync
  describe WorkingDir, "f_write" do

    let(:fs_dir){ File.dirname(__FILE__) }
    let(:wdir)  { WorkingDir.new(fs_dir) }
    let(:path){ "a-new-file.txt" }
    let(:exp_path){ File.expand_path("../#{path}", __FILE__) }

    specify "it should work" do
      wdir.f_write(path, "content")
      File.read(exp_path).should eq("content")
    end

    after{ FileUtils.rm_rf(exp_path) }

  end
end
