require 'grit'
module WebSync
  class WorkingDir

    # The working directory
    attr_reader :fs_dir

    # Creates a WorkingDir instance
    def initialize(fs_dir)
      if fs_dir.is_a?(Grit::Repo)
        @grit_repo, fs_dir = fs_dir, fs_dir.working_dir
      end
      unless File.directory?(fs_dir)
        raise ArgumentError, "File does not exists #{fs_dir}"
      end
      @fs_dir = fs_dir
    end

    # Writes `content` to the file at `path`
    def f_write(path, content)
      File.open(File.join(fs_dir,path), "w"){|f| f << content}
    end

    # Appends `content` to the file at `path`
    def f_append(path, content)
      File.open(File.join(fs_dir,path), "a"){|f| f << content}
    end

    # Reads the content to the file at `path`
    def f_read(path)
      File.read(File.join(fs_dir,path))
    end

    # Removes the file at `path`
    def f_delete(path)
      FileUtils.rm_rf(File.join(fs_dir,path))
    end

    # Checks if a file exists
    def exists?(f)
      File.exists?(File.join(fs_dir, f))
    end

    class Git < WorkingDir

      # Returns the list of pending changes on the local copy
      def pending_changes
        # pending changes are
        #   <=> either an untracked (but not ignored) or one whose status is not
        #       nil ('A', 'M', 'D')
        #   <=> any?{|f| f.untracked && !f.ignored} || any?{|f| !f.type.nil?}
        #   <=> any?{|f| (f.untracked && !f.ignored) || !f.type.nil? }
        gritrepo.status.select{|f|
          (f.untracked && !f.ignored) || !f.type.nil?
        }
      end

      # Is there pending changes on the local copy?
      def has_pending_changes?
        not(pending_changes.empty?)
      end

      # Returns the list of unpulled bugfixes
      def available_bug_fixes
        gritrepo.git.rev_list({}, "^master", "origin/master").
                     split("\n").
                     map{|id| gritrepo.commit(id)}
      end

      # Is there bug fixes availables for the local copy?
      def has_available_bug_fixes?
        not(available_bug_fixes.empty?)
      end

      # Returns the list of unpushed commits
      def unpushed_commits
        gritrepo.git.rev_list({}, "master", "^origin/master").
                     split("\n").
                     map{|id| gritrepo.commit(id)}
      end

      # Does the local copy have unpushed commits?
      def has_unpushed_commits?
        not(unpushed_commits.empty?)
      end

      # Returns true if this working directory is purely in sync 
      # with the origin repository
      def in_sync?
        !(has_pending_changes? || 
          has_unpushed_commits? || 
          has_available_bug_fixes?)
      end

      def save(commit_message)
        to_be_added = pending_changes.select{|f|
          f.untracked && f.type.nil?
        }
        gritrepo.add(*to_be_added.map{|f| f.path})
        gritrepo.commit_all(commit_message)
      end

      def push_origin(opts = {})
        gritrepo.git.push(opts, "origin")
      end

      private 

      def gritrepo
        @gritrepo ||= Grit::Repo.new(fs_dir)
      end

    end # class Git

  end # class WorkingDir
end # module WebSync
