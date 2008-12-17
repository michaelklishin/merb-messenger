$LOAD_PATH.unshift(File.dirname(__FILE__))

# make sure we're running inside Merb
if defined?(Merb::Plugins)
  # Register path for messengers under app/messengers
  Merb.push_path(:messenger, Merb.root / "app"/ "messengers")
  
  require "merb_messenger/messaging_controller"
  require "merb_messenger/messaging_mixin"
  
  module Merb
    module Messenger
      @@test_deliveries = Hash.new([])

      def self.clean_test_deliveries!
        @@test_deliveries = Hash.new([])
      end
      
      def self.test_deliveries
        @@test_deliveries
      end

      def setup_transport(name, type, options)
        ::Merb::MessagingController.message_transport(name, type, options)
      end

      module_function :setup_transport
    end
  end

  Merb::Plugins.config[:merb_messenger] = {
  }
    
  Merb::Plugins.add_rakefiles "merb_messenger/merbtasks"
end
