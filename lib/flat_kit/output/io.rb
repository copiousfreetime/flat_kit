# frozen_string_literal: true

module FlatKit
  class Output
    class IO < Output
      attr_reader :count

      STDOUTS = %w[stdout STDOUT - <stdout>]
      STDERRS = %w[stderr STDERR <stderr>]

      def self.handles?(obj)
        return true if is_stderr?(obj)
        return true if is_stdout?(obj)
        return true if [::File, ::StringIO, ::IO].any? { |klass| obj.kind_of?(klass) }

        false
      end

      def self.is_stderr?(obj)
        case obj
        when String
          return true if STDERRS.include?(obj)
        when ::IO
          return true if obj == ::STDERR
        end
        false
      end

      def self.is_stdout?(obj)
        case obj
        when String
          return true if STDOUTS.include?(obj)
        when ::IO
          return true if obj == ::STDOUT
        end
        false
      end

      def initialize(obj)
        @count = 0
        if self.class.is_stdout?(obj)
          @name = "<STDOUT>"
          @io = $stdout
        elsif self.class.is_stderr?(obj)
          @name = "<STDERR>"
          @io = $stderr
        elsif obj.kind_of?(::File)
          @name = obj.path
          @io = obj
        elsif obj.kind_of?(::StringIO)
          @name = obj.inspect
          @io = obj
        elsif obj.kind_of?(::IO)
          @name = obj.inspect
          @io = obj
        else
          raise ::FlatKit::Error, "Unable to create #{self.class} from #{obj.class} : #{obj.inspect}"
        end
      end

      def name
        @name
      end

      # this goes to an io stream and we are not in charge of opening it
      def close
        @io.close
      end

      # internal api method for testing
      def io
        @io
      end
    end
  end
end
