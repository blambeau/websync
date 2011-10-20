module WebSync
  class Middleware
    class Model

      attr_reader :agent

      def initialize(agent)
        @agent = agent
      end

      def working_dir
        agent.working_dir
      end

      def pending_changes
        @pending_changes ||= working_dir.pending_changes
      end

      def pending_changes?
        not(pending_changes.empty?)
      end

      def to_be_added
        pending_changes.select{|c| c.operation == "add"}
      end

      def to_be_updated
        pending_changes.select{|c| c.operation == "update"}
      end

      def to_be_removed
        pending_changes.select{|c| c.operation == "remove"}
      end

      def may_import?
        @may_import ||= agent.may_sync_local?
      end

      def may_save?
        @may_save ||= agent.may_save?
      end

      def may_deploy?
        @may_deploy ||= agent.may_sync_repo?
      end

      def explain_no_deploy
        if not(agent.unpushed_commits?)
          "Nothing to deploy for now."
        elsif agent.pending_changes?
          "Unable to deploy. Save pending changes first."
        elsif agent.bug_fixes_available?
          "Unable to deploy. Import new updates first."
        else
          "Unable to deploy. I must confess that I don't know why."
        end
      end

    end # class Model
  end # class Middleware
end # module WebSync
