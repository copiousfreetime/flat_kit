# frozen_string_literal: true

module FlatKit
  module Jsonl
    # Internal: Reader class that parses and yields records from JSONL files
    #
    class Reader < ::FlatKit::Reader
      attr_reader :input, :count

      def self.format_name
        ::FlatKit::Jsonl::Format.format_name
      end

      def initialize(source:, compare_fields: :none)
        super
        @input = ::FlatKit::Input.from(source)
        @count = 0
      end

      def each
        while (line = input.io.gets)
          record = ::FlatKit::Jsonl::Record.new(data: line, compare_fields: compare_fields)
          @count += 1
          yield record
        end
        input.close
      rescue StandardError => e
        ::FlatKit.logger.error "Error reading jsonl records from #{input.name}: #{e}"
        raise ::FlatKit::Error, e
      end
    end
  end
end
