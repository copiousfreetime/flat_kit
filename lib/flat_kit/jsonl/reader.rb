module FlatKit
  module Jsonl
    class Reader < ::FlatKit::Reader
      attr_reader :input
      attr_reader :count

      def initialize(source:, compare_fields:)
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
