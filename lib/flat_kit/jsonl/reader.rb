# frozen_string_literal: true

module FlatKit
  module Jsonl
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
        while line = input.io.gets do
          record = ::FlatKit::Jsonl::Record.new(data: line, compare_fields: compare_fields)
          @count += 1
          yield record
        end
        input.close
      rescue => e
        ::FlatKit.logger.error "Error reading jsonl records from #{input.name}: #{e}"
        raise ::FlatKit::Error, e
      end
    end
  end
end
