module FlatKit
  module Jsonl
    class Writer < ::FlatKit::Writer
      attr_reader :output
      attr_reader :count

      def initialize(destination:)
        super
        @output = ::FlatKit::Output.from(@destination)
        @count = 0
      end

      def write(record)
        case record
        when FlatKit::Jsonl::Record
          output.io.write(record.to_s)
          @count += 1
        when FlatKit::Record
          converted_record = ::FlatKit::Jsonl::Record.from_record(record)
          output.io.write(converted_record.to_s)
          @count += 1
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
    end
  end
end
