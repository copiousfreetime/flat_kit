module FlatKit
  # Collect stats on a single field. We may not know what the field data type is
  # to start with, so collect a bunch of values until we have the threshold, and
  # then calculte states based upon the data types determined by the guess
  #
  class FieldStats
    DEFAULT_GUESS_THRESHOLD = 1000

    CORE_STATS = :core
    CARDINALITY_STATS = :cardinality

    ALL_STATS = [ CORE_STATS, CARDINALITY_STATS ]

    # DEFAULT_STATS = %w[
    #   count max mean min stddev sum
    #   null_count percent_nulls
    #   unknown_count percent_unknown
    # ].freeze

    attr_reader :type_counts
    attr_reader :field_type

    def initialize(name:, stats_to_collect: CORE_STATS, type: ::FlatKit::FieldType::GuessType, guess_threshold: DEFAULT_GUESS_THRESHOLD)
      @name              = name
      @field_type        = type
      @guess_threshold   = guess_threshold
      @type_counts       = Hash.new(0)
      @out_of_type_count = 0
      @values            = []
      @stats             = nil
      @stats_to_collect  = [stats_to_collect].flatten

      @stats_to_collect.each do |collection_set|
        next if ALL_STATS.include?(collection_set)
        raise ArgumentError, "#{collection_set} is not a valid stats collection set, must be one of #{ALL_STATS.map { |s| s.to_s }.join(", ") }"
      end
      raise ArgumentError, "type: must be FieldType subclasses - not #{type}" unless type.kind_of?(Class) && (type.superclass == ::FlatKit::FieldType)
    end

    def field_type_determined?
      @field_type != ::FlatKit::FieldType::GuessType
    end

    def update(value)
      update_type_count(value)

      if field_type_determined? then
        update_stats(value: value)
      else
        @values << value

        if @values.size >= @guess_threshold then
          resolve_guess
        end
      end
    end

    def collecting_frequencies?
      @stats_to_collect.include?(CARDINALITY_STATS)
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

    def null_count
      type_counts[FieldType::NullType]
    end

    def total_count
      stats.count + @out_of_type_count
    end

    def null_percent
      return 0 if total_count.zero?
      null_count.to_f / total_count
    end

    def unknown_count
      type_counts[FieldType::UnknownType]
    end

    def unknown_percent
      return 0 if total_count.zero?
      unknown_count.to_f / total_count
    end

    private

    def stats
      if !field_type_determined? then
        resolve_guess
      end
      @stats
    end

    def update_stats(value)
      coerced_value = @field_type.coerce(value)
      if coerced_value == FieldType::CoerceFailure then
        @out_of_type_count += 1
        return
      end

      @stats.update(coerced_value)
      update_cardinality_stats(coerced_value)
    end

    def update_cardinality_stats(value)
      if @stats_to_collect.include?(CARDINALITY_STATS) then

      end
    end

    def update_type_count(value)
      guess = FieldType.best_guess(value)
      type_counts[guess] += 1
      return guess
    end

    def resolve_guess
      best_guess_type, _best_guess_count = type_counts.max_by { |k, v| v }
      @field_type = best_guess_type
      @stats = StatType.for(@field_type).new(collecting_frequencies: collecting_frequencies?)
      @values.each do |v|
        update_stats(v)
      end
      @values.clear
    end
  end
end
