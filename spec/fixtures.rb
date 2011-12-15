module WebSync
  module Fixtures

    def tmpdir(*args)
      Dir.mktmpdir(*args)
    end 

    def the_bare_repository_folder
      @the_bare_repository_folder ||= tmpdir("bare_origin")
    end

    def the_bare_repository
      @the_bare_repository ||= begin
        FileUtils.rm_rf(the_bare_repository_folder)
        repo = Repository::Git.create(the_bare_repository_folder)
        repo.clone(tmpdir("bare_clone")) do |cl|

          (cl/"README.md").write   "Hey hey hey, this is the project!\n"
          (cl/"ignored.txt").write "This is an ignored file\n"
          (cl/".gitignore").write  "ignored.txt\ntmp\n"
          cl.save_and_push("A first commit")

          (cl/"index.html").write "Hello World!"
          cl.save_and_push("A first website version")
          cl.tag("v1.0.0")

          (cl/"index.html").write "Hello World!!"
          (cl/"htaccess").write "something"
          cl.save_and_push("A first bugfix")
        end
        repo
      end
    end

    def an_in_sync_clone 
      @an_in_sync_clone ||= an_in_sync_clone!
    end

    def an_in_sync_clone!
      the_bare_repository.clone(tmpdir("in_sync_clone"))
    end

    def a_modified_clone
      @a_modified_clone ||= a_modified_clone!
    end

    def a_modified_clone!
      the_bare_repository.clone(tmpdir("a_modified_clone")) do |wd|
        (wd/"README.md").rm
        (wd/'ADDED.md').write "this is an added file"
        (wd/".gitignore").append "*.tmp\n"
      end
    end

    def a_backwards_clone
      @a_backwards_clone ||= a_backwards_clone!
    end

    def a_backwards_clone!
      the_bare_repository.clone(tmpdir("a_backwards_clone")) do |wd|
        wd.reset("v1.0.0")
      end
    end

    def a_forward_clone
      @a_forward_clone ||= a_forward_clone!
    end

    def a_forward_clone!
      the_bare_repository.clone(tmpdir("a_forward_clone")) do |wd|
        (wd/"index.html").write "Hello World!! and even more"
        wd.save("And even more")
      end
    end

    def a_forward_and_backwards_clone
      @a_forward_and_backwards_clone ||= a_forward_and_backwards_clone!
    end

    def a_forward_and_backwards_clone!
      the_bare_repository.clone(tmpdir("a_forward_and_backwards_clone")) do |wd|
        wd.reset("v1.0.0")
        (wd/"newpage.html").write "A second page content"
        wd.save("A second page")
      end
    end

    def a_corrupted_clone
      WorkingDir::Git.new(tmpdir("a_corrupted_clone"))
    end

    extend(self)
  end # module Fixtures
end # module WebSync
#Grit.debug = true
#WebSync::Fixtures.a_backwards_clone
