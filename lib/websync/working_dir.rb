require 'grit'
module WebSync
  class WorkingDir

    # The underlying path
    attr_reader :path

    # Creates a WorkingDir instance
    #
    # @param [Path] path to the working dir instance
    def initialize(path)
      @path = Path.new(path)
      unless @path.directory?
        raise ArgumentError, "Not a valid working dir #{fs_dir}"
      end
    end

    # Creates a WorkingDir instance from `arg`
    def self.coerce(arg)
      if arg.is_a?(WorkingDir)
        arg
      elsif arg.is_a?(Grit::Repo)
        WorkingDir::Git.new(arg.working_dir)
      elsif arg.respond_to?(:to_str)
        WorkingDir::Git.new(arg.to_str)
      else
        raise ArgumentError, "Invalid argument #{arg} for `WorkingDir`"
      end
    end

    # @return [Path] a path to the file denoted by `self.path/file`
    def /(file)
      self.path / file
    end

  end # class WorkingDir
end # module WebSync
require 'websync/working_dir/git'
