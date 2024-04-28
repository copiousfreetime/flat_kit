# frozen_string_literal: true

require_relative "../test_helper"

module TestStatType
  class TestNumericalStats < ::Minitest::Test
    def setup
      @stats = FlatKit::StatType::NumericalStats.new
      @full_stats = FlatKit::StatType::NumericalStats.new
      @all_stats = FlatKit::StatType::NumericalStats.new(collecting_frequencies: true)
      [1, 2, 3].each { |i| @full_stats.update(i) }
    end

    def test_intialized_with_usable_values
      assert_equal(0, @stats.count)
      assert_equal(Float::INFINITY, @stats.min)
      assert_equal(-Float::INFINITY, @stats.max)
      assert_in_delta(0.0, @stats.sum)
      assert_in_delta(0.0, @stats.rate)
    end

    def test_calculates_mean
      assert_in_delta(2.0, @full_stats.mean)
    end

    def test_calculates_rate
      assert_in_delta(0.5, @full_stats.rate)
    end

    def test_tracks_the_maximum_value
      assert_in_delta(3.0, @full_stats.max)
    end

    def test_tracks_the_minimum_value
      assert_in_delta(1.0, @full_stats.min)
    end

    def test_tracks_the_count
      assert_equal(3, @full_stats.count)
    end

    def test_tracks_the_sum
      assert_in_delta(6.0, @full_stats.sum)
    end

    def test_calculates_the_standard_deviation
      assert_in_delta(1.0, @full_stats.stddev)
    end

    def test_calculates_the_sum_of_squares
      assert_equal(14, @full_stats.sumsq)
    end

    def test_converts_to_a_hash
      h = @full_stats.to_hash

      assert_equal(::FlatKit::StatType::NumericalStats.default_stats.size, h.size)
      assert_equal(::FlatKit::StatType::NumericalStats.default_stats, h.keys.sort)
    end

    def test_converts_to_a_limited_hash_if_given_arguments
      h = @full_stats.to_hash("min", "max", "mean")

      assert_equal(3, h.size)
      assert_equal(%w[max mean min], h.keys.sort)

      h = @full_stats.to_hash(%w[count rate])

      assert_equal(2, h.size)
      assert_equal(%w[count rate], h.keys.sort)
    end

    def test_raises_nomethoderror_if_an_invalid_stat_is_used
      assert_raises(NoMethodError) { @full_stats.to_hash("wibble") }
    end

    def test_converts_to_a_json_string
      j = @full_stats.to_json
      h = JSON.parse(j)

      assert_equal(::FlatKit::StatType::NumericalStats.default_stats.size, h.size)
      assert_equal(::FlatKit::StatType::NumericalStats.default_stats, h.keys.sort)
    end

    def test_converts_to_a_limited_json_hash_if_given_arguments
      j = @full_stats.to_json("min", "max", "mean")
      h = JSON.parse(j)

      assert_equal(3, h.size)
      assert_equal(%w[max mean min], h.keys.sort)

      j = @full_stats.to_json(%w[count rate])
      h = JSON.parse(j)

      assert_equal(2, h.size)
      assert_equal(%w[count rate], h.keys.sort)
    end

    def test_raises_nomethoderror_if_an_invalid_json_stat_is_used
      assert_raises(NoMethodError) { @full_stats.to_json("wibble") }
    end

    def test_collects_mode
      values = [].tap do |a|
        100.times do
          n = Random.rand(10)
          a << n
          @all_stats.update(n)
        end
      end

      tally = values.tally
      mode_value = tally.max_by { |v, count| count }.first

      assert_equal(mode_value, @all_stats.mode)
    end

    def test_collecting_frequences_reports_extra_stat_names
      stat_names = @all_stats.collected_stats

      assert_includes(stat_names, "mode")
      assert_includes(stat_names, "unique_count")
      assert_includes(stat_names, "unique_values")
    end
  end
end
