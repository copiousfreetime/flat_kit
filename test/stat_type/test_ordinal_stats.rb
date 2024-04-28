# frozen_string_literal: true

require_relative "../test_helper"

module TestStatType
  class TestOrdinalStats < ::Minitest::Test
    def setup
      today = Date.today
      next_month = today >> 1
      last_day_of_month = (next_month - 1).mday

      @start_date = Date.new(today.year, today.month, 1)
      @end_date   = Date.new(today.year, today.month, last_day_of_month)

      @unique_values = (@start_date..@end_date).to_a
      @values = Array.new.tap do |a|
        @unique_values.each do |date|
          (Random.rand(42) + 1).times { a << date}
        end
      end

      @frequencies = @values.tally

      @stats = ::FlatKit::StatType::OrdinalStats.new
      @all_stats = ::FlatKit::StatType::OrdinalStats.new(collecting_frequencies: true)

      @values.each do |v|
        @stats.update(v)
        @all_stats.update(v)
      end
    end

    def test_count
      assert_equal(@values.size, @stats.count)
      assert_equal(@values.size, @all_stats.count)
    end

    def test_min
      assert_equal(@values.min, @stats.min)
      assert_equal(@values.min, @all_stats.min)
    end

    def test_max
      assert_equal(@values.max, @stats.max)
      assert_equal(@values.max, @all_stats.max)
    end

    def test_does_not_collect_unique_count_by_default
      assert_nil(@stats.unique_count)
    end

    def test_does_not_collect_unique_values_by_default
      assert_nil(@stats.unique_values)
    end

    def test_does_not_collect_frequencies_by_default
      assert_nil(@stats.frequencies)
    end

    def test_unique_count
      assert_equal(@unique_values.size, @all_stats.unique_count)
    end

    def test_unique_values
      assert_equal(@unique_values.sort, @all_stats.unique_values.sort)
    end

    def test_frequencies
      assert_equal(@frequencies, @all_stats.frequencies)
    end

    def test_default_to_hash
      expecting = {
        "count" => @values.size,
        "max" => @values.max,
        "min" => @values.min,
      }

      assert_equal(expecting, @stats.to_hash)
    end

    def test_all_stats_hash
      expecting = {
        "count" => @values.size,
        "unique_count" => @unique_values.size,
        "unique_values" => @unique_values.sort,
        "mode" => @frequencies.max_by { |k, v| v }.first,
        "max" => @values.max,
        "min" => @values.min,
      }

      assert_equal(expecting, @all_stats.to_hash)
    end
  end
end

