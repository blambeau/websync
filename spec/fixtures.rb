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
          cl.f_write("README.md", "Hey hey hey, this is the project!\n")
          cl.f_write("ignored.txt", "This is an ignored file\n")
          cl.f_write(".gitignore", "ignored.txt\n")
          cl.save("Initial repository layout.")
          cl.push_origin(:u => true)
        end
        repo
      end
    end

    def an_in_sync_clone 
      @an_in_sync_clone ||= begin
        the_bare_repository.clone(tmpdir("in_sync_clone"))
      end
    end

    def a_modified_clone
      @a_modified_clone ||= begin
        the_bare_repository.clone(tmpdir("a_modified_clone")) do |wd|
          wd.f_delete("README.md")
          wd.f_write('ADDED.md', "this is an added file")
          wd.f_append(".gitignore", "*.tmp\n")
        end
      end
    end

    extend(self)
  end # module Fixtures
end # module WebSync
