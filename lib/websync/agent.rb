module WebSync
  class Agent

    # The bus instance to use for inter-agent communications
    attr_reader :bus

    # Creates an agent instance with a communication bus
    def initialize(bus = nil)
       @bus = bus
    end

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

  end # class Agent
end # module WebSycn
