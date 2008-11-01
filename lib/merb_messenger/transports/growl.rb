require 'ruby-growl'

module Merb
  module Messenger
    class GrowlTransport  
      class_inheritable_accessor :_default_delivery_options
      self._default_delivery_options = Mash.new

      def self.delivery_options(options)
        self._default_delivery_options = options
      end

      attr_reader :transport

      def initialize(options)
        @transport = ::Growl.new(options[:host], options[:application], options[:notifications])
      end

      def connect
      end

      def disconnect
      end

      def deliver(options = {})
        options = _default_delivery_options.merge(options)

        self.transport.notify(options[:notification], options[:title], options[:body])
      end    
    end
  end
end
