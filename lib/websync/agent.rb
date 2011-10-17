module WebSync
  class Agent

    ############################################################ Robustness
    protected

      def req_pre!(operation, expr, expected)
        yield unless self.send(expr) == expected
      end

      def dom_post!(operation, expr, expected)
        unless self.send(expr) == expected
          raise AssertError, 
                "DomPost #{expected ? '' : '!'} #{expr} expected for #{operation}"
        end
      end

      def req_post!(operation, expr, expected)
        unless self.send(expr) == expected
          raise AssertError, 
                "ReqPost #{expected ? '' : '!'} #{expr} expected for #{operation}"
        end
      end

    ############################################################ Events
    public

      def listen(match = nil, &block)
        @listeners ||= []
        @listeners << [match, block]
      end

    protected

      def signal(event, *args)
        return unless defined?(@listeners)
        @listeners.each do |match, block|
          next unless match.nil? || match === event
          block.call(self, event, *args)
        end
      end

      def self.upon(agent, event, &block)
        @upon ||= []
        @upon << [agent, event, block]
      end

  end # class Agent
end # module WebSycn
