# frozen_string_literal: true

require "zlib"
require "pathname"

module FlatKit
  class Input
    class File < Input
      attr_reader :path, :count

      def self.handles?(obj)
        return true if obj.instance_of?(Pathname)
        return false unless obj.instance_of?(String)

        # incase these get loaded in different orders
        return false if ::FlatKit::Input::IO.is_stdin?(obj)

        return true
      end

      def initialize(obj)
        @count = 0
        @path = Pathname.new(obj)
        raise FlatKit::Error, "Input #{obj} is not readable" unless @path.readable?

        @io = open_input(path)
      end

      def name
        path.to_s
      end

      def close
        @io.close
      end

      def io
        @io
      end

      private

      # open the opropriate input type depending on the source file name
      #
      # TODO: add in bzip
      def open_input(path)
        case path.extname
        when ".gz"
          Zlib::GzipReader.open(path.to_s)
        else
          path.open("rb")
        end
      end
    end
  end
end
