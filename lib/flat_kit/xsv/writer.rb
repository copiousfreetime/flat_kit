# frozen_string_literal: true

module FlatKit
  module Xsv
    # Internal: Write that takes flatkit records and writes them to XSV Output
    #
    class Writer < ::FlatKit::Writer
      attr_reader :fields, :header_bytes

      def self.format_name
        ::FlatKit::Xsv::Format.format_name
      end

      def self.default_csv_options
        {
          headers: nil,
          write_headers: true,
        }
      end

      def initialize(destination:, fields: :auto, **csv_options)
        super(destination: destination)
        @fields = fields
        @we_write_the_header = nil
        @csv_options = Writer.default_csv_options.dup

        if @fields == :auto
          @we_write_the_header = true
        else
          @csv_options[:headers] = fields
          @we_write_the_header = false
        end

        @header_bytes = 0
        @csv_options.merge!(csv_options)
        @csv = CSV.new(output.io, **@csv_options)
      end

      # write the record and return the Position the record was written
      #
      # In the case of the header being written automatcially, the Postion returned is the
      # position of the reocrd, not the header
      #
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
      rescue FlatKit::Error => e
        raise e
      rescue StandardError => e
        ::FlatKit.logger.error "Error writing xsv records to #{output.name}: #{e}"
        raise ::FlatKit::Error, e
      end

      private

      def write_record(record)
        if @we_write_the_header && @count.zero?
          @csv << record.ordered_fields
          @header_bytes = output.tell
        end

        # the index of the record being written is the same as the count of records written so far
        record_index = @count

        # get the current output stream position to calculate bytes written
        start_offset = output.tell

        @csv << record.to_a

        ending_offset = output.io.tell
        bytes_written = (ending_offset - start_offset)

        @count += 1

        @last_position = ::FlatKit::Position.new(index: record_index,
                                                 offset: start_offset,
                                                 bytesize: bytes_written)
      end
    end
  end
end
