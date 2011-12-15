require 'grit'
module WebSync
  #
  # A working dir is a local version of a source code repository called "origin".
  #
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

    ###################################################################### State

    # Is the local copy clean?
    #
    # @return [Boolean] true if if there are no local uncommited changes on the 
    # local copy. Uncommited changes include modified, deleted and added files 
    # (except explicitely ignored ones).
    def clean?
      pending_changes.empty?
    end

    # The inverse of `clean?`
    def dirty?
      !clean?
    end

    # Does the origin have commits that are not shared by the working dir?
    #
    # @return [Boolean] true if such commits exist, false otherwise
    def backward?
      !unmerged_commits.empty?
    end

    # Does the working dir have commits that have not been pushed back to the 
    # origin.
    #
    # @return [Boolean] true if such commits exist, false otherwise
    def forward?
      !unpushed_commits.empty?
    end

    # Is the local copy strictly synchronized with the origin?
    #
    # @return [Boolean] true iif (clean? and !backward and !forward)
    def synchronized?
      !(dirty? or backward? or forward?)
    end

    ################################################################## Operation

    # Creates a commit by saving local changes.
    #
    # @dom-pre  dirty?
    # @dom-post clean?
    # @req-post [for Avoid(AutoPushToOrigin)] is_forward?
    # @param [String] message a commit description
    # @return [WorkingDir] self
    def save(message)
      self
    end
    undef :save

    # Pushes local commits to the origin.
    #
    # @dom-pre  forward?
    # @dom-post !forward
    # @req-pre  [for Maintain(LinearHistory)] !backward?
    # @return [WorkingDir] self
    def push
      self
    end
    undef :push

    # Pull unmerged commits from the origin
    #
    # @dom-pre  backward?
    # @dom-post !backward?
    # @return [WorkingDir] self
    def pull
      self
    end
    undef :pull

  end # class WorkingDir
end # module WebSync
require 'websync/working_dir/git'
