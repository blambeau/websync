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
        repo = Repository::Git.create(the_bare_repository_folder)
        repo.clone(tmpdir("bare_clone")) do |cl|
          cl.f_write("README.md", "Hey hey hey, this is the project!\n")
          cl.f_write("ignored.txt", "This is an ignored file\n")
          cl.f_write(".gitignore", "ignored.txt\n")
          cl.save
          cl.push_origin
        end
        repo
      end
    end

    extend(self)
  end # module Fixtures
end # module WebSync
