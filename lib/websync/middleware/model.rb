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
          @cache[name] ||= delegate(name, *args, &block)
        else
          delegate(name, *args, &block)
        end
      end

      def pending_changes
        working_dir.pending_changes
      end

      def to_be_added
        pending_changes.select{|c| c.untracked || (c.type == 'A')}
      end

      def to_be_updated
        pending_changes.select{|c| c.type == 'M'}
      end

      def to_be_removed
        pending_changes.select{|c| c.type == 'D'}
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

      def commit_history
        unpushed = unpushed_commits
        if unpushed.empty?
          working_dir.send(:gritrepo).commits
        else
          working_dir.send(:gritrepo).commits(unpushed.last.id)
        end
      end

      private

        def delegate(method, *args, &block)
          if agent.respond_to?(method)
            agent.send(method, *args, &block)
          elsif working_dir.respond_to?(method)
            working_dir.send(method, *args, &block)
          else
            raise NoMethodError, "No such method #{method}"
          end
        end

    end # class Model
  end # class Middleware
end # module WebSync
