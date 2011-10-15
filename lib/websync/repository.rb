module WebSync
  class Repository
    class Git < Repository

      # Path to the repository
      attr_reader :path

      # Creates a Repository instance bound to a path
      def initialize(path)
        @path = path
      end

      # Clones the repository and returns a WorkingDir instance
      # on `where`.
      def clone(where)
        unless self.class.empty_dir?(where)
          raise ArgumentError, "File already exists `#{where}`"
        end
        FileUtils.mkdir_p(where)
        g = Grit::Git.new(where)
        g.clone({}, "--", path, where)
        wdir = WorkingDir::Git.new(where)
        yield(wdir) if block_given?
        wdir
      end

      # Creates a bare git repository in `fs_dir`
      def self.create(fs_dir)
        unless empty_dir?(fs_dir)
          raise ArgumentError, "File already exists `#{fs_dir}`"
        end

        # create the bare repository
        FileUtils.mkdir_p fs_dir
        Grit::Repo.init_bare(fs_dir)

        # clones it and add a new README
        Dir.mktmpdir do |dir|
          r = preclone(fs_dir, dir)
          gitignore = File.join(dir, ".gitignore")
          FileUtils.touch(gitignore)
          r.add(gitignore)
          r.commit_all("Initial repository layout")
          r.git.push({:u => true}, "origin", "master")
        end

        new(fs_dir)
      end

      # tools

        def self.preclone(path, where)
          r = Grit::Repo::init(where)
          r.remote_add("origin", path)
          r.remote_update
          r
        end

        def self.empty_dir?(dir)
          !File.exists?(dir) || (
            File.directory?(dir) && 
            Dir.glob("#{dir}/*", File::FNM_DOTMATCH).size == 2
          )
        end

    end # class Git
  end # class Repository
end # module WebSync
