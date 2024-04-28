# frozen_string_literal: true

module FlatKit
  class StatType
    # Same as NominalStats and also collects min and max
    #
    class OrdinalStats < NominalStats
      attr_reader :min, :max

      def self.default_stats
        @default_stats ||= %w[count max min]
      end

      def self.all_stats
        @all_stats ||= %w[count max min unique_count unique_values mode]
      end

      def initialize(collecting_frequencies: false)
        super
        @min = nil
        @max = nil
      end

      def update(value)
        @mutex.synchronize do
          if @min.nil? || (value < @min) then
            @min = value
          end

          if @max.nil? || (value > @max) then
            @max = value
          end

          @count += 1

          @frequencies[value] += 1 if @collecting_frequencies
        end
      end
    end
  end
end
