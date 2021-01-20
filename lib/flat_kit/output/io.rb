module FlatKit
  class Output
    class IO < Output

      STDOUTS = %w[ stdout STDOUT - ]
      STDERRS = %w[ stderr STDERR ]

      def self.handles?(obj)
        return true if is_stderr?(obj)
        return true if is_stdout?(obj)
        return true if obj.kind_of?(::IO)
        return false
      end

      def self.is_stderr?(obj)
        case obj
        when String
          return true if STDERRS.include?(obj)
        when ::IO
          return true if obj == ::STDERR
        end
        return false
      end

      def self.is_stdout?(obj)
        case obj
        when String
          return true if STDOUTS.include?(obj)
        when ::IO
          return true if obj == ::STDOUT
        end
        return false
      end

      def initialize(obj)
        if self.class.is_stdout?(obj) then
          @name = "<STDOUT>"
          @io = $stdout
        elsif self.class.is_stderr?(obj) then
          @name = "<STDERR>"
          @io = $stderr
        elsif obj.kind_of?(::File) then
          @name = obj.path
          @io = obj
        elsif obj.kind_of?(::IO) then
          @name = obj.inspect
          @io = obj
        else
          raise ::FlatKit::Error, "Unable to create #{self.class} from #{obj.class} : #{obj.inspect}"
        end
      end

      def name
        @name
      end

      def io
        @io
      end
    end
  end
end
