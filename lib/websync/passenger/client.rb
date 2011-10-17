require 'json'
require 'http'
module WebSync
  module Passenger
    #
    # Client-side agent for Passenger-oriented deployment.
    #
    class Client

      # Host to contact
      attr_accessor :url

      def initialize
        yield(self) if block_given?
      end

      def call
        Http.accept(:json).post(url)
      end

    end # class Client
  end # module Passenger
end # module WebSync
