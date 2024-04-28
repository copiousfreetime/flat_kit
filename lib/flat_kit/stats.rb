# frozen_string_literal: true

module FlatKit
  class Stats
    include ::FlatKit::EventEmitter

    AllFields = Class.new.freeze

    attr_reader :reader, :writer, :fields_to_stat, :stats_to_collect, :stats_by_field

    def initialize(input:, input_fallback: "auto",
                   output:, output_fallback: "auto",
                   fields_to_stat: AllFields, stats_to_collect: FieldStats::CORE_STATS)

      @fields_to_stat   = fields_to_stat
      @stats_to_collect = stats_to_collect
      @stats_by_field   = Hash.new
      @record_count     = 0

      @reader = ::FlatKit::Reader.create_reader_from_path(path: input, fallback: input_fallback)
      @writer = ::FlatKit::Writer.create_writer_from_path(path: output, fallback: output_fallback,
                                                          reader_format: @reader.format_name)
    end

    def call
      calculate_stats
      write_stat_records
      @writer.close
    end

    def collecting_stats_on_field?(name)
      return true if @fields_to_stat == AllFields

      return @fields_to_stat.include?(name)
    end

    private

    def calculate_stats
      ::FlatKit.logger.debug "Calculating statistics on #{reader.source}"
      reader.each do |record|
        record.to_hash.each do |field_name, field_value|
          if collecting_stats_on_field?(field_name)
            update_stats_for_field(name: field_name, value: field_value)
          end
        end
        @record_count += 1
      end
    end

    def update_stats_for_field(name:, value:)
      field_stats = @stats_by_field[name] ||= FieldStats.new(name: name, stats_to_collect: @stats_to_collect)
      field_stats.update(value)
    end

    def write_stat_records
      @stats_by_field.each do |name, stats|
        h = stats.to_hash.merge({"total_record_count" => @record_count })
        record = ::FlatKit::Jsonl::Record.new(data: nil, complete_structured_data: h)

        @writer.write(record)
      end
    end
  end
end
