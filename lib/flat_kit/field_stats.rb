# frozen_string_literal: true

module FlatKit
  # Collect stats on a single field. We may not know what the field data type is
  # to start with, so collect a bunch of values until we have the threshold, and
  # then calculte states based upon the data types determined by the guess
  #
  class FieldStats
    DEFAULT_GUESS_THRESHOLD = 1000

    CORE_STATS = :core
    CARDINALITY_STATS = :cardinality

    ALL_STATS = [CORE_STATS, CARDINALITY_STATS]

    EXPORT_FIELDS = %w[
      name
      type
      count
      max
      mean
      min
      stddev
      sum
      mode
      unique_count

      max_length
      mean_length
      min_length
      stddev_length
      mode_length
      unique_count_lengths

      null_count
      unknown_count
      out_of_type_count
      total_count
      null_percent
      unknown_percent
    ]

    attr_reader :type_counts, :field_type, :name

    def initialize(name:, stats_to_collect: CORE_STATS, type: ::FlatKit::FieldType::GuessType, guess_threshold: DEFAULT_GUESS_THRESHOLD)
      @name              = name
      @field_type        = type
      @guess_threshold   = guess_threshold
      @type_counts       = Hash.new(0)
      @out_of_type_count = 0
      @values            = []
      @stats             = nil
      @length_stats      = nil
      @stats_to_collect  = [stats_to_collect].flatten

      @stats_to_collect.each do |collection_set|
        next if ALL_STATS.include?(collection_set)

        raise ArgumentError, "#{collection_set} is not a valid stats collection set, must be one of #{ALL_STATS.map { |s| s.to_s }.join(", ") }"
      end
      raise ArgumentError, "type: must be FieldType subclasses - not #{type}" unless type.is_a?(Class) && (type.superclass == ::FlatKit::FieldType)
    end

    def field_type_determined?
      @field_type != ::FlatKit::FieldType::GuessType
    end

    def update(value)
      update_type_count(value)

      if field_type_determined?
        update_stats(value)
      else
        @values << value

        resolve_guess if @values.size >= @guess_threshold
      end
    end

    def collecting_frequencies?
      @stats_to_collect.include?(CARDINALITY_STATS)
    end

    def type
      @field_type.type_name
    end

    def count
      stats.count
    end

    def max
      stats.max if stats.respond_to?(:max)
    end

    def mean
      stats.mean if stats.respond_to?(:mean)
    end

    def min
      stats.min if stats.respond_to?(:min)
    end

    def stddev
      stats.stddev if stats.respond_to?(:stddev)
    end

    def sum
      stats.sum if stats.respond_to?(:sum)
    end

    def mode
      stats.mode if collecting_frequencies?
    end

    def unique_count
      stats.unique_count if collecting_frequencies?
    end

    def unique_values
      stats.unique_values if collecting_frequencies?
    end

    def frequencies
      stats.frequencies if collecting_frequencies?
    end

    def min_length
      length_stats.min if @length_stats
    end

    def max_length
      length_stats.max if @length_stats
    end

    def mean_length
      length_stats.mean if @length_stats
    end

    def stddev_length
      length_stats.stddev if @length_stats
    end

    def mode_length
      length_stats.mode if @length_stats && collecting_frequencies?
    end

    def unique_count_lengths
      length_stats.unique_count if @length_stats && collecting_frequencies?
    end

    def unique_values_lengths
      length_stats.unique_values if @length_stats && collecting_frequencies?
    end

    def length_frequencies
      length_stats.frequencies if @length_stats && collecting_frequencies?
    end

    def null_count
      type_counts[FieldType::NullType]
    end

    def total_count
      stats.count + @out_of_type_count
    end

    def out_of_type_count
      @out_of_type_count
    end

    def null_percent
      return 0 if total_count.zero?

      ((null_count.to_f / total_count) * 100.0).truncate(2)
    end

    def unknown_count
      type_counts[FieldType::UnknownType]
    end

    def unknown_percent
      return 0 if total_count.zero?

      ((unknown_count.to_f / total_count) * 100.0).truncate(2)
    end

    def to_hash
      resolve_guess

      {}.tap do |h|
        EXPORT_FIELDS.each do |n|
          h[n] = send(n)
        end
      end
    end

    private

    def stats
      resolve_guess
      @stats
    end

    def length_stats
      resolve_guess
      @length_stats
    end

    def update_stats(value)
      coerced_value = @field_type.coerce(value)
      if coerced_value == FieldType::CoerceFailure
        @out_of_type_count += 1
        return
      end

      @stats.update(coerced_value)
      @length_stats.update(coerced_value.to_s.length) if @length_stats
    end

    def update_type_count(value)
      guess = FieldType.best_guess(value)
      type_counts[guess] += 1
      guess
    end

    def resolve_guess
      return if field_type_determined?

      best_guess_type, _best_guess_count = type_counts.max_by { |k, v| v }
      @field_type = best_guess_type
      @stats = StatType.for(@field_type).new(collecting_frequencies: collecting_frequencies?)
      @length_stats = ::FlatKit::StatType::NumericalStats.new(collecting_frequencies: collecting_frequencies?) if @field_type == ::FlatKit::FieldType::StringType
      @values.each do |v|
        update_stats(v)
      end
      @values.clear
    end
  end
end
