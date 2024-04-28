# frozen_string_literal: true

module FlatKit
  module Jsonl
    class Writer < ::FlatKit::Writer
      def self.format_name
        ::FlatKit::Jsonl::Format.format_name
      end

      # write the record and return the Position the record was written
      #
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
      rescue FlatKit::Error => e
        raise e
      rescue StandardError => e
        ::FlatKit.logger.error "Error writing jsonl records to #{output.name}: #{e}"
        raise ::FlatKit::Error, e
      end

      def write_record(record)
        # the index of the record being written is the same as the count of records written so far
        record_index = @count

        # get the current output stream position to calculate bytes written
        start_offset = output.io.tell

        # enforces ending in newline if it doesn't already have one
        output.io.puts record.to_s

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
