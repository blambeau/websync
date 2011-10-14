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
        # pending changes 
        #   <=> either an untracked or one whose status is not nil ('A', 'M', 'D')
        #   <=> any?{|f| f.untracked} || any?{|f| !f.type.nil?}
        #   <=> any?{|f| f.untracked || !f.type.nil? }
        gritrepo.status.any?{|f| f.untracked || !f.type.nil? }
      end

      # Is there bug fixes availables for the local copy?
      def bug_fixes_available?
      end

      # Does the local copy have local savings?
      def local_savings?
      end

      private 

      def gritrepo
        @gritrepo ||= Grit::Repo.new(working_dir)
      end

    end # class GitRepo
  end # class Repository
end # module WebSync
