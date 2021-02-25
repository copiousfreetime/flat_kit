module FlatKit
  class Stats
    include ::FlatKit::EventEmitter

    DEFAULT_STATS = %i[ min max mean stddev sum ].freeze

    attr_reader :reader
    attr_reader :writer
    attr_reader :stat_fields
    attr_reader :stats_to_collect

    def initialize(input:, input_fallback: "auto",
                   output:, output_fallback: "auto",
                   stat_fields:, stats_to_collect: DEFAULT_STATS)
      @stat_fields = stat_fields.dup
      @stats_to_collect = stats_to_collect.dup
      @reader = ::FlatKit::Reader.create_reader_from_path(path: input, fallback: input_fallback)
      @writer = ::FlatKit::Writer.create_writer_from_path(path: output, fallback: output_fallback,
                                                          reader_format: @reader.format_name)
    end

    def call
      ::FlatKit.logger.debug "Calculating statistics on #{reader.source}"
    end
  end
end
