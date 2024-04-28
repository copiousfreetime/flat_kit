# frozen_string_literal: true

require "zlib"
require "pathname"

module FlatKit
  class Output
    class File < Output
      attr_reader :path

      # internal api method for testing purposes
      attr_reader :io

      def self.handles?(obj)
        return true if obj.instance_of?(Pathname)
        return false unless obj.instance_of?(String)

        # incase these get loaded in different orders
        return false if ::FlatKit::Output::IO.is_stdout?(obj)
        return false if ::FlatKit::Output::IO.is_stderr?(obj)

        true
      end

      def initialize(obj)
        super()
        @path = Pathname.new(obj)
        path.dirname.mkpath
        @io = open_output(path)
      end

      def name
        path.to_s
      end

      def close
        @io.close
      end

      private

      # open the opropriate otuput type depending on the destination file name
      #
      # TODO: add in bzip
      def open_output(path)
        case path.extname
        when ".gz"
          Zlib::GzipWriter.open(path.to_s)
        # when ".gz"
        #   ::IO.popen("gzip -c > #{path}", "w")
        else
          path.open("wb")
        end
      end
    end
  end
end
