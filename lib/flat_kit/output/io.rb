# frozen_string_literal: true

module FlatKit
  class Output
    # Internal: Non-file Output impelementation - this is genrally to stdout or stderr
    #
    class IO < Output
      attr_reader :count, :name

      # internal api method for testing
      attr_reader :io

      STDOUTS = %w[stdout STDOUT - <stdout>].freeze
      STDERRS = %w[stderr STDERR <stderr>].freeze

      def self.handles?(obj)
        return true if stderr?(obj)
        return true if stdout?(obj)
        return true if [::File, ::StringIO, ::IO].any? { |klass| obj.is_a?(klass) }

        false
      end

      def self.stderr?(obj)
        case obj
        when String
          return true if STDERRS.include?(obj)
        when ::IO
          return true if obj == $stderr
        end
        false
      end

      def self.stdout?(obj)
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
        @name = nil
        @io = nil
        init_name_and_io(obj)
      end

      # this goes to an io stream and we are not in charge of opening it
      def close
        @io.close
      end

      private

      def init_name_and_io(obj)
        if self.class.stdout?(obj)
          @name = "<STDOUT>"
          @io = $stdout
        elsif self.class.stderr?(obj)
          @name = "<STDERR>"
          @io = $stderr
        elsif obj.is_a?(::IO)
          @name = (obj.respond_to?(:path) && obj.path) || obj.inspect
          @io = obj
        elsif obj.is_a?(::StringIO)
          @name = obj.inspect
          @io = obj
        else
          raise ::FlatKit::Error, "Unable to create #{self.class} from #{obj.class} : #{obj.inspect}"
        end
      end
    end
  end
end
