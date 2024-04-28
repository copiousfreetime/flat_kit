# frozen_string_literal: true

module FlatKit
  class StatType
    # Status object to keep track of the count and frequency of values
    #
    class NominalStats < StatType
      attr_reader :count

      def self.default_stats
        @default_stats ||= %w[count]
      end

      def self.all_stats
        @all_stats ||= %w[count unique_count unique_values mode]
      end

      def initialize(collecting_frequencies: false)
        @mutex = Mutex.new
        @count = 0
        @collecting_frequencies = collecting_frequencies
        @frequencies = Hash.new(0)
      end

      def collected_stats
        return self.class.default_stats unless @collecting_frequencies

        return self.class.all_stats
      end

      def mode
        return nil unless @collecting_frequencies

        @frequencies.max_by{ |item, item_count| item_count }.first
      end

      def unique_count
        return nil unless @collecting_frequencies

        @frequencies.size
      end

      def unique_values
        return nil unless @collecting_frequencies

        @frequencies.keys
      end

      def frequencies
        return nil unless @collecting_frequencies

        @frequencies
      end

      def update(value)
        @mutex.synchronize do
          @count += 1
          @frequencies[value] += 1 if @collecting_frequencies
        end
      end
    end
  end
end
