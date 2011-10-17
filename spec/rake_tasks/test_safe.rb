require "spec_helper"
require "websync/rake_tasks"
module WebSync
  describe RakeTasks, "safe" do

    let(:tasks){ RakeTasks.new }

    context "when nothing goes wrong" do
      subject{ tasks.safe("[Message...]"){ :result } }

      context "when silent is not set" do
        specify{
          out, err = capture_io{ subject.should eq(:result) }
          out.should eq("[Message...] done!\n")
          err.should be_empty
        }
      end

      context "when silent is set" do
        before{ 
          tasks.silent = true 
        }
        specify{
          out, err = capture_io{ subject.should eq(:result) }
          out.should be_empty
          err.should be_empty
        }
      end

    end # nothing goes wrong

    context "when something goes wrong" do
      subject{ tasks.safe("[Message...]"){ raise "Error!" } }


      context "when silent is not set" do
        specify{
          out, err = capture_io{ subject.should be_nil }
          out.should eq("[Message...] failed.\n")
          err.should match(/^Sorry, something goes wrong\nError!\n/)
        }
      end

      context "when silent is set" do
        before{ 
          tasks.silent = true 
        }
        specify{
          out, err = capture_io{ subject.should be_nil }
          out.should be_empty
          err.should match(/^Sorry, something goes wrong\nError!\n/)
        }
      end

    end

  end
end
