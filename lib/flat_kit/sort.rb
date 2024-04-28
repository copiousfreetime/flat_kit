# frozen_string_literal: true

module FlatKit
  class Sort
    attr_reader :reader, :writer, :compare_fields

    def initialize(input:, input_fallback: "auto",
                   output:, output_fallback: "auto",
                   compare_fields:)

      @compare_fields = compare_fields
      @reader = ::FlatKit::Reader.create_reader_from_path(path: input, compare_fields: @compare_fields,
                                                          fallback: input_fallback)
      @writer = ::FlatKit::Writer.create_writer_from_path(path: output, fallback: output_fallback,
                                                          reader_format: @reader.format_name)
    end

    def call
      ::FlatKit.logger.info "Sorting #{reader.source} into #{writer.destination} using key #{compare_fields.join(", ")}"
      records = [].tap do |a|
        reader.each do |r|
          a << r
        end
      end
      ::FlatKit.logger.info "Read #{reader.count} records into #{records.size} element array"
      records.sort!
      ::FlatKit.logger.info "Sorted #{records.size} records"
      records.each do |r|
        writer.write(r)
      end
      writer.close
      ::FlatKit.logger.info "Wrote #{writer.count} records to #{writer.destination}"
    end
  end
end
