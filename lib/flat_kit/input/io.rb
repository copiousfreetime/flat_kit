# frozen_string_literal: true

module FlatKit
  class Input
    # Internal: Handler for non-filebased input. Generally this is just stdin
    #
    class IO < Input
      STDINS = %w[stdin STDIN - <stdin>].freeze

      def self.handles?(obj)
        return true if stdin?(obj)
        return true if [::File, ::StringIO, ::IO].any? { |klass| obj.is_a?(klass) }

        false
      end

      def self.stdin?(obj)
        case obj
        when String
          return true if STDINS.include?(obj)
        when ::IO
          return true if obj == $stdin
        end
        false
      end

      def initialize(obj)
        super()
        if self.class.stdin?(obj)
          @name = "<STDIN>"
          @io = $stdin
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

      attr_reader :name, :io

      # this goes to an io stream and we are not in charge of opening it
      def close
        @io.close
      end
    end
  end
end
