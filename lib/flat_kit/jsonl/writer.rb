module FlatKit
  module Jsonl
    class Writer < ::FlatKit::Writer
      attr_reader :output
      @count = 0
      @byte_count = 0

      def self.format_name
        ::FlatKit::Jsonl::Format.format_name
      end

      def initialize(destination:)
        super
        @output = ::FlatKit::Output.from(@destination)
      end

      def write(record)
        case record
        when FlatKit::Jsonl::Record
          write_record(record)
        when FlatKit::Record
          converted_record = ::FlatKit::Jsonl::Record.from_record(record)
          write_record(converted_record)
        else
          raise FlatKit::Error, "Unable to write records of type #{record.class}"
        end
      rescue FlatKit::Error => fe
        raise fe
      rescue => e
        ::FlatKit.logger.error "Error reading jsonl records from #{output.name}: #{e}"
        raise ::FlatKit::Error, e
      end

      def close
        @output.close
      end

      def write_record(record)
        # enforces ending in newlin if it doesn't already have one
        output.io.puts record.to_s
        @byte_count = output.io.tell
        @count += 1
      end
    end
  end
end
