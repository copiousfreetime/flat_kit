# frozen_string_literal: true

module FlatKit
  class Input
    class IO < Input
      STDINS = %w[stdin STDIN - <stdin>]

      def self.handles?(obj)
        return true if is_stdin?(obj)
        return true if [::File, ::StringIO, ::IO].any? { |klass| obj.kind_of?(klass) }

        false
      end

      def self.is_stdin?(obj)
        case obj
        when String
          return true if STDINS.include?(obj)
        when ::IO
          return true if obj == ::STDIN
        end
        false
      end

      def initialize(obj)
        if self.class.is_stdin?(obj)
          @name = "<STDIN>"
          @io = $stdin
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

      def io
        @io
      end
    end
  end
end
