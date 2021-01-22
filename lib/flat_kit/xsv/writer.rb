module FlatKit
  module Xsv
    class Writer < ::FlatKit::Writer
      attr_reader :output
      attr_reader :count
      attr_reader :fields

      def self.format_name
        ::FlatKit::Xsv::Format.format_name
      end

      def self.default_csv_options
        {
          headers: nil,
          write_headers: true
        }
      end

      def initialize(destination:, fields: :auto, **csv_options)
        super(destination: destination)
        @fields = fields
        @output = ::FlatKit::Output.from(@destination)
        @count = 0
        @we_write_the_header = nil
        @csv_options = Writer.default_csv_options.dup

        if @fields == :auto then
          @we_write_the_header = true
        else
          @csv_options.merge!(headers: fields)
          @we_write_the_header = false
        end

        @csv_options.merge!(csv_options)
        @csv = CSV.new(output.io, **@csv_options)
      end

      def write(record)
        case record
        when FlatKit::Xsv::Record
          write_record(record)
        when FlatKit::Record
          converted_record = ::FlatKit::Xsv::Record.from_record(record, ordered_fields: @fields)
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

      private

      def write_record(record)
        if @we_write_the_header && @count == 0 then
          @csv << record.ordered_fields
        end
        @count += 1
        @csv << record.to_a
      end
    end
  end
end
