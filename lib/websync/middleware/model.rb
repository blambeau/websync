module WebSync
  class Middleware
    class Model

      attr_reader :agent

      def initialize(agent)
        @agent = agent
        @cache = {}
      end

      def method_missing(name, *args, &block)
        if args.empty? && block.nil?
          @cache[name] ||= agent.send(name, *args, &block)
        else
          agent.send(name, *args, &block)
        end
      end

      def pending_changes
        working_dir.pending_changes
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
