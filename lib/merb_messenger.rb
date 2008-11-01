$LOAD_PATH.unshift(File.dirname(__FILE__))

# make sure we're running inside Merb
if defined?(Merb::Plugins)
  puts "Loaded merb_messenger..."

  # Register path for messengers under app/messengers
  Merb.push_path(:messenger, Merb.root / "app"/ "messengers")
  
  require "merb_messenger/messengers/growl"
  # TODO: lazy loading
  require "merb_messenger/messengers/xmpp"
  
  require "merb_messenger/messaging_controller"
  require "merb_messenger/messaging_mixin"

  
  module Merb
    module Messenger

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
