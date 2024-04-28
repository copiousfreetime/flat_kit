# frozen_string_literal: true

module FlatKit
  # Internal: Class implementing merging from N inputs and output to 1 output.
  #
  class Merge
    include ::FlatKit::EventEmitter

    attr_reader :readers, :writer, :compare_fields

    def initialize(inputs:, output:, compare_fields:, input_fallback: "auto", output_fallback: "auto")
      @compare_fields = compare_fields
      @readers = ::FlatKit::Reader.create_readers_from_paths(paths: inputs, compare_fields: @compare_fields,
                                                             fallback: input_fallback)
      @writer  = ::FlatKit::Writer.create_writer_from_path(path: output, fallback: output_fallback,
                                                           reader_format: @readers.first.format_name)
    end

    def call
      ::FlatKit.logger.debug "Merging the following files into #{writer.destination}"
      ::FlatKit.logger.debug "Using this key for sorting: #{compare_fields.join(', ')}"
      readers.each do |r|
        ::FlatKit.logger.debug "  #{r.source}"
      end

      run_merge(readers)

      readers.each do |r|
        ::FlatKit.logger.debug "  #{r.source} produced #{r.count} records"
      end

      writer.close
      ::FlatKit.logger.debug "Wrote #{writer.count} records to #{writer.destination}"
    end

    private

    def run_merge(readers)
      tree = ::FlatKit::MergeTree.new(readers)
      notify_listeners(name: :start, data: :start)
      tree.each do |record|
        position = writer.write(record)
        meta = { position: position }
        notify_listeners(name: :record, data: record, meta: meta)
      end
      notify_listeners(name: :stop, data: :stop)
    end
  end
end
