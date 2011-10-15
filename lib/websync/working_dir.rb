require 'grit'
module WebSync
  class WorkingDir

    # The working directory
    attr_reader :fs_dir

    # Creates a WorkingDir instance
    def initialize(fs_dir)
      @fs_dir = fs_dir
    end

    class Git < WorkingDir

      # Is there pending changes on the local copy?
      def has_pending_changes?
        # pending changes are
        #   <=> either an untracked (but not ignored) or one whose status is not
        #       nil ('A', 'M', 'D')
        #   <=> any?{|f| f.untracked && !f.ignored} || any?{|f| !f.type.nil?}
        #   <=> any?{|f| (f.untracked && !f.ignored) || !f.type.nil? }
        gritrepo.status.any?{|f| (f.untracked && !f.ignored) || !f.type.nil? }
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

      private 

      def gritrepo
        @gritrepo ||= Grit::Repo.new(fs_dir)
      end

    end # class Git

  end # class WorkingDir
end # module WebSync
