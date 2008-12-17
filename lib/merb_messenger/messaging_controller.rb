module Merb
  class MessagingController < AbstractController
    #include Merb::Messenger::Transport
    
    attr_reader :params, :web_controller
    
    class_inheritable_accessor :_message_transports, :_default_delivery_options
    
    self._message_transports       = Mash.new
    self._default_delivery_options = Mash.new
    
    cattr_accessor :_subclasses
    self._subclasses = Set.new
    
    
    render_options :format => :text    
    
    def self.subclasses_list
      _subclasses
    end
    
    def _template_location(action, type = :text, controller = controller_name)
      "#{controller}/#{action}.#{type}"
    end
    
    def _absolute_template_location(template, type)
      template.match(/\.#{type.to_s.escape_regexp}$/) ? template : "#{template}.#{type}"
    end
    
    def self.inherited(klass)
      _subclasses << klass.to_s
      super
      
      klass._template_root ||= Merb.dir_for(:messenger) / "views"
    end
    
    
    def self.dispatch(message, web_controller, options = {}, msg_options = {})
      self.new(web_controller, options).__send__(message, msg_options)
    end
    
    def self.message_transport(name = :default, type = nil, options = nil)
      return self._message_transports[name] if type.blank?
      
      klass = Merb::Messenger.const_get("#{type.to_s.camel_case}Transport")
      t     = klass.new(options)
      self._message_transports[name] = t
    end
    
    def self.delivery_options(name = :default, value = nil)
      return self._default_delivery_options[name] unless value
      self._default_delivery_options[name] = value
    end
    
    
    
    def initialize(web_controller, opts = {})
      @web_controller = web_controller
      @params         = Mash.new(@web_controller.params.dup)
      
      @params.merge!(opts) unless opts.blank?
      super
      
      @content_type   = @web_controller.content_type
    end
    
    def transport
      self.class._transport
    end
    
    def deliver(client = :default, options = {})
      opts = (self._default_delivery_options[client] || {}).
            merge(self.params).
            merge(options)
      
      [opts[:to]].flatten.each do |to|
        self._message_transports[client].deliver(opts.merge(:to => to))
      end
    end
    
    def session
      self.web_controller.request.session rescue {}
    end

    def request
      self.web_controller.request
    end
    
    # Mimic the behavior of absolute_url in AbstractController
    # but use @web_controller.request
    def url(name, *args)
      return web_controller.url(name, *args) if web_controller
      super
    end

    alias_method :relative_url, :url

    # Mimic the behavior of absolute_url in AbstractController
    # but use @web_controller.request
    def absolute_url(name, *args)
      return web_controller.absolute_url(name, *args) if web_controller
      super
    end    
    
  end
end
