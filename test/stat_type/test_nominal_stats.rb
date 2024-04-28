# frozen_string_literal: true

require_relative "../test_helper"

module TestStatType
  class TestNominalStats < ::Minitest::Test
    def setup
      @unique_values = ("a".."f").to_a
      @values = Array.new.tap do |a|
        @unique_values.each do |letter|
          (Random.rand(42) + 1).times { a << letter }
        end
      end

      @frequencies = @values.tally

      @stats = ::FlatKit::StatType::NominalStats.new
      @all_stats = ::FlatKit::StatType::NominalStats.new(collecting_frequencies: true)

      @values.each do |v|
        @stats.update(v)
        @all_stats.update(v)
      end
    end

    def test_count
      assert_equal(@values.size, @stats.count)
      assert_equal(@values.size, @all_stats.count)
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
      expecting = { "count" => @values.size }

      assert_equal(expecting, @stats.to_hash)
    end

    def test_all_stats_hash
      expecting = {
        "count" => @values.size,
        "unique_count" => @unique_values.size,
        "unique_values" => @unique_values.sort,
        "mode" => @frequencies.max_by { |k,v| v }.first
      }

      assert_equal(expecting, @all_stats.to_hash)
    end
  end
end

