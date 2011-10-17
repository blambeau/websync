module WebSync
  describe WorkingDir, ".coerce" do

    let(:root){ File.expand_path("../../..", __FILE__) }
    subject{ WorkingDir.coerce(arg) }

    context "on Grit::Repo" do 
      let(:arg){ Grit::Repo.new(root) }
      it{ should be_a(WorkingDir) }
    end

    context "on String" do
      let(:arg){ root }
      it{ should be_a(WorkingDir) }
    end

    context "on WorkingDir" do
      let(:arg){ WorkingDir.new(root) }
      it{ should eq(arg) }
    end

  end
end
