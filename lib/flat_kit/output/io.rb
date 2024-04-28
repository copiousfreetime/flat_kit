# frozen_string_literal: true

module FlatKit
  class Output
    class IO < Output
      attr_reader :count, :name

      # internal api method for testing
      attr_reader :io

      STDOUTS = %w[stdout STDOUT - <stdout>].freeze
      STDERRS = %w[stderr STDERR <stderr>].freeze

      def self.handles?(obj)
        return true if is_stderr?(obj)
        return true if is_stdout?(obj)
        return true if [::File, ::StringIO, ::IO].any? { |klass| obj.is_a?(klass) }

        false
      end

      def self.is_stderr?(obj)
        case obj
        when String
          return true if STDERRS.include?(obj)
        when ::IO
          return true if obj == $stderr
        end
        false
      end

      def self.is_stdout?(obj)
        case obj
        when String
          return true if STDOUTS.include?(obj)
        when ::IO
          return true if obj == $stdout
        end
        false
      end

      def initialize(obj)
        super()
        @count = 0
        if self.class.is_stdout?(obj)
          @name = "<STDOUT>"
          @io = $stdout
        elsif self.class.is_stderr?(obj)
          @name = "<STDERR>"
          @io = $stderr
        elsif obj.is_a?(::IO)
          @name = obj.path || obj.inspect
          @io = obj
        elsif obj.is_a?(::StringIO)
          @name = obj.inspect
          @io = obj
        else
          raise ::FlatKit::Error, "Unable to create #{self.class} from #{obj.class} : #{obj.inspect}"
        end
      end

      # this goes to an io stream and we are not in charge of opening it
      def close
        @io.close
      end
    end
  end
end
