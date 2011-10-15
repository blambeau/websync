module WebSync
  describe WorkingDir, "exists?" do
    let(:fs_dir){ File.dirname(__FILE__) }
    let(:wdir)  { WorkingDir.new(fs_dir) }
    subject{ wdir.exists?(file) }

    context "on an existing file" do 
      let(:file){ "test_exists.rb" }
      it{ should be_true }
    end

    context "on a non-existing file" do 
      let(:file){ "no-such-file.txt" }
      it{ should be_false }
    end

    context "on a more complex path" do 
      let(:file){ "../working_dir/test_exists.rb" }
      it{ should be_true }
    end

  end
end
