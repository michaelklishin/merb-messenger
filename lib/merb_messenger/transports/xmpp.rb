require 'xmpp4r/client'

module Merb
  module Messenger
    class Xmpp4rTransport
      include ::Jabber

      class_inheritable_accessor :_default_delivery_options
      self._default_delivery_options = Mash.new(:message_type => :chat)

      def self.delivery_options(options)
        self._default_delivery_options = options
      end

      attr_reader :transport

      def initialize(options)
        @transport = Client.new(options[:jid])
        @transport.connect
        
        @transport.auth(options[:password])
      end

      def connect
        self.transport.connect
      end

      def disconnect
        self.transport.close
      end

      def deliver(options = {})
        options = _default_delivery_options.merge(options)
        
        m = Message.new(options[:to], options[:body])
        
        m.set_subject(options[:subject]) if options[:subject]
        m.set_subject(options[:id])      if options[:id]
        m.set_type(options[:message_type] || :normal)
        
        self.transport.send(m)
      end
    end
  end
end