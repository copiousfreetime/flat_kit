# frozen_string_literal: true

module FlatKit
  module Jsonl
    # Internal: JSONL format class holding the metadata about the JSONL format
    #
    class Format < ::FlatKit::Format
      def self.format_name
        "jsonl"
      end

      def self.handles?(filename)
        parts = filename.split(".")
        %w[json jsonl ndjson].each do |ext|
          return true if parts.include?(ext)
        end
        false
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
