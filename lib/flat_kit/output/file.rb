module FlatKit
  class Output
    class File < Output
      attr_reader :path

      def self.handles?(obj)
        return true if obj.instance_of?(Pathname)
        return false unless obj.instance_of?(String)

        # incase these get loaded in different orders
        return false if ::FlatKit::Output::IO.is_stdout?(obj)
        return false if ::FlatKit::Output::IO.is_stderr?(obj)

        return true
      end

      def initialize(obj)
        @path = Pathname.new(obj)
        path.dirname.mkpath
        @io = path.open("w")
      end

      def name
        path.to_s
      end

      def close
        @io.close
      end

      # internal api method
      def io
        @io
      end

    end
  end
end
