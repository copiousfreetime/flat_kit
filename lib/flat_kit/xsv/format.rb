module FlatKit
  module Xsv
    class Format < ::FlatKit::Format
      def self.format_name
        "xsv"
      end

      def self.handles?(filename)
        parts = filename.split(".")
        %w[ csv tsv txt ].each do |ext|
          return true if parts.include?(ext)
        end
        return false
      end

      def self.reader
        ::FlatKit::Xsv::Reader
      end

      def self.writer
        ::FlatKit::Xsv::Writer
      end
    end
  end
end
