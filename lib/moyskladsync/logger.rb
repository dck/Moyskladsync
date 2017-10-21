module Moyskladsync
  class Logger
    class << self
      def method_missing(method, *args, &block)
        logger.__send__(method, *args, &block)
      end

      def respond_to_missing?(method, include_private = false)
        logger.respond_to_missing?(method, include_private)
      end

      private

      def logger
        Thread.current[:logger] ||= ::Logger.new(log_io).tap do |l|
          l.level = 'DEBUG'
        end
      end

      def log_io
        STDOUT.sync = true
        STDOUT
      end
    end
  end
end
