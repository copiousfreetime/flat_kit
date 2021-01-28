module FlatKit
  class Merge

    include ::FlatKit::Observable

    attr_reader :readers
    attr_reader :writer
    attr_reader :compare_fields

    def initialize(inputs:, input_fallback: "auto",
                   output:, output_fallback: "auto",
                   compare_fields:)
      @compare_fields = compare_fields
      @readers = ::FlatKit::Reader.create_readers_from_paths(paths: inputs, compare_fields: @compare_fields,
                                                             fallback: input_fallback)
      @writer  = ::FlatKit::Writer.create_writer_from_path(path: output, fallback: output_fallback,
                                                           reader_format: @readers.first.format_name)
    end

    def call
      ::FlatKit.logger.info "Merging the following files into #{writer.destination}"
      ::FlatKit.logger.info "Using this key for sorting: #{compare_fields.join(", ")}"
      readers.each do |r|
        ::FlatKit.logger.info "  #{r.source}"
      end

      merge_tree = ::FlatKit::MergeTree.new(readers)
      merge_tree.each do |record|
        notify_observers(record)
        writer.write(record)
      end
      readers.each do |r|
        ::FlatKit.logger.info "  #{r.source} produced #{r.count} records"
      end
      writer.close
      ::FlatKit.logger.info "Wrote #{writer.count} records to #{writer.destination}"
    end
  end
end
