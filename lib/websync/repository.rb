require 'grit'
module WebSync
  class Repository
    class GitRepo < Repository

      DEFAULT_OPTIONS = {
        :origin => :origin
      }

      # The working directory
      attr_reader :working_dir

      # Options
      attr_reader :options

      def initialize(working_dir, options = {})
        @working_dir = working_dir
        @options = DEFAULT_OPTIONS.merge(options)
      end

      # Is there pending changes on the local copy?
      def pending_changes?
        # pending changes are
        #   <=> either an untracked (but not ignored) or one whose status is not
        #       nil ('A', 'M', 'D')
        #   <=> any?{|f| f.untracked && !f.ignored} || any?{|f| !f.type.nil?}
        #   <=> any?{|f| (f.untracked && !f.ignored) || !f.type.nil? }
        gritrepo.status.any?{|f| (f.untracked && !f.ignored) || !f.type.nil? }
      end

      # Returns the list of unpulled bugfixes
      def bug_fixes_available
        gritrepo.git.rev_list({}, "^master", "origin/master").
                     split("\n").
                     map{|id| gritrepo.commit(id)}
      end

      # Is there bug fixes availables for the local copy?
      def bug_fixes_available?
        !bug_fixes_available.empty?
      end

      # Returns the list of unpushed commits
      def unpushed_commits
        gritrepo.git.rev_list({}, "master", "^origin/master").
                     split("\n").
                     map{|id| gritrepo.commit(id)}
      end

      # Does the local copy have unpushed commits?
      def unpushed_commits?
        !unpushed_commits.empty?
      end

      private 

      def gritrepo
        @gritrepo ||= Grit::Repo.new(working_dir)
      end

    end # class GitRepo
  end # class Repository
end # module WebSync
