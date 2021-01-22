module FlatKit
  module Xsv
    class Writer < ::FlatKit::Writer
      attr_reader :output
      attr_reader :count
      attr_reader :fields

      def self.default_csv_options
        {
          headers: nil,
          write_headers: true
        }
      end

      def initialize(destination:, fields:, **csv_options)
        super(destination: destination)
        @fields = fields
        @output = ::FlatKit::Output.from(@destination)
        @count = 0
        @csv_options = Writer.default_csv_options.merge(headers: fields).merge(csv_options)
        @csv = CSV.new(output.io, **@csv_options)
      end

      def write(record)
        case record
        when FlatKit::Xsv::Record
          @csv << record.to_a
          @count += 1
        when FlatKit::Record
          converted_record = ::FlatKit::Xsv::Record.from_record(record, ordered_fields: @fields)
          @csv << converted_record.to_a
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
