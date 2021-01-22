module FlatKit
  module Jsonl
    class Format < ::FlatKit::Format
      def self.handles?(filename)
        parts = filename.split(".")
        %w[ json jsonl ndjson ].each do |ext|
          return true if parts.include?(ext)
        end
        return false
      end

      def self.reader
        ::FlatKit::Jsonl::Reader
      end

      def self.writer
        ::FlatKit::Jsonl::Writer
      end
    end
  end
end
