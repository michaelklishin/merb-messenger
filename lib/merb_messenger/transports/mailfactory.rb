module Merb
  module Messenger
    class MailTransport
      attr_reader :delivery_strategy, :composition_strategy

      class_inheritable_accessor :_default_delivery_options
      self._default_delivery_options = Mash.new(:message_type => :chat)

      def self.delivery_options(options)
        self._default_delivery_options = options
      end

      def initialize(options)
        @delivery_strategy    = options[:deliver_with] || :sendmail
        @composition_strategy = options[:compose_with] || :mailfactory
      end

      def deliver(options = {})
        options = _default_delivery_options.merge(options)

        email = case self.composition_strategy
                when :mailfactory then compose_with_mailfactory(options)
                when :tmail       then compose_with_tmail(options)
                when Proc         then self.composition_strategy.call(options)
                when Class        then compose_with_custom_strategy(options)
                else
                  self.send "compose_with_#{self.composition_strategy}"
                end

        case self.delivery_strategy
        when :sendmail, :send_mail      then deliver_with_sendmail(email, options)
        when :smtp, :netsmtp, :net_smtp then deliver_with_smtp(email, options)
        when Proc                       then self.delivery_strategy.call(email, options)
        when Class                      then deliver_with_custom_strategy(email, options)
        else
          self.send "deliver_with_#{self.delivery_strategy}"
        end
      end

      protected

      def compose_with_mailfactory(options)
        email         = MailFactory.new
        email.from    = options[:from]

        [options[:reply_to] || []].flatten.each do |address|
          email.add_header "Reply-To", address
        end
        [options[:to] || []].flatten.each do |address|
          email.add_header "To", address
        end
        [options[:cc] || []].flatten.each do |address|
          email.add_header "Cc", address
        end

        email.subject = options[:subject] if options[:subject]
        email.text    = options[:text]    if options[:text]
        email.html    = options[:html]    if options[:html]

        email
      end

      def compose_with_tmail(options)
        # TODO
      end

      def compose_with_custom_strategy(options)
        # TODO
      end

      def deliver_with_sendmail(email, options)
        if Merb.testing?
          Merb::Messenger.test_deliveries[:email].push email
        else
          recepients = [options[:to] || []].flatten.join(',')
          Merb.logger.info! "Sending email with sendmail #{recepients}"
          IO.popen("sendmail #{recepients}", 'w+') do |sendmail|
            sendmail.puts email.to_s
          end
        end
      end # deliver_with_sendmail

      def deliver_with_smtp(email, options)
        # TODO
      end

      def deliver_with_custom_strategy(email, options)
        # TODO
      end # deliver_with_custom_strategy
    end
  end
end
