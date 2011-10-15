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
        FileUtils.mkdir_p where
        repo = Grit::Repo.init(where)
        repo.remote_add("origin", path)
        repo.remote_update
        wdir = WorkingDir::Git.new(repo)
        yield(wdir) if block_given?
        wdir
      end

      # Creates a bare git repository in `fs_dir`
      def self.create(fs_dir)
        unless empty_dir?(fs_dir)
          raise ArgumentError, "File already exists `#{fs_dir}`"
        end
        FileUtils.mkdir_p fs_dir
        Grit::Repo.init_bare(fs_dir)
        new(fs_dir)
      end

      # tools

        def self.empty_dir?(dir)
          !File.exists?(dir) || (
            File.directory?(dir) && 
            Dir.glob("#{dir}/*", File::FNM_DOTMATCH).size == 2
          )
        end

    end # class Git
  end # class Repository
end # module WebSync
