# frozen_string_literal: true

require_relative "test_helper"

require "faker"

class TestFieldStats < Minitest::Test
  # returns [FieldStats, Array] where the array is the original data
  def generate_data_with(count: 100, stats: ::FlatKit::FieldStats.new(name: "data"), &block)
    list = [].tap do |a|
      count.times do
        n = block.call
        stats.update(n)
        a << n
      end
    end
    [stats, list]
  end

  def test_raises_error_on_invalid_stats
    assert_raises(ArgumentError) { ::FlatKit::FieldStats.new(name: "test", stats_to_collect: :whatever) }
  end

  def test_collects_numeric_default_stats
    field_stats, number_data = generate_data_with { Faker::Number.within(range: 1.0..100.0) }

    null_count = 5
    null_count.times do
      field_stats.update(nil)
    end

    avg = number_data.sum / number_data.size
    min = number_data.min
    max = number_data.max
    sum = number_data.sum

    refute(field_stats.field_type_determined?)

    assert_equal(null_count, field_stats.null_count)
    assert_equal(number_data.size, field_stats.count)

    assert(field_stats.field_type_determined?)

    assert_in_epsilon(avg, field_stats.mean)
    assert_equal(min, field_stats.min)
    assert_equal(max, field_stats.max)
    assert_in_epsilon(sum, field_stats.sum)
    expected_percent = (null_count.to_f / (null_count + number_data.size)) * 100.0

    assert_in_epsilon(expected_percent, field_stats.null_percent)
  end

  def test_collect_numeric_cardinality_stats
    field_stats = ::FlatKit::FieldStats.new(name: "number-cardinality",
                                            stats_to_collect: ::FlatKit::FieldStats::ALL_STATS)
    field_stats, number_data = generate_data_with(stats: field_stats) do
      Faker::Number.within(range:1..25)
    end

    avg = number_data.sum.to_f / number_data.size
    min = number_data.min
    max = number_data.max

    assert(field_stats.collecting_frequencies?)
    refute(field_stats.field_type_determined?)

    assert_equal(number_data.size, field_stats.count)

    assert(field_stats.field_type_determined?)

    assert_in_epsilon(avg, field_stats.mean)
    assert_equal(min, field_stats.min)
    assert_equal(max, field_stats.max)

    assert_equal(number_data.tally.keys.size, field_stats.unique_count)
    assert_equal(number_data.tally.keys.sort, field_stats.unique_values.sort)
    assert_equal(number_data.tally, field_stats.frequencies)

    mode = number_data.tally.max_by{ |_k, v| v }.first

    assert_equal(mode, field_stats.mode)
  end

  def test_unknown_type_stats
    field_stats = ::FlatKit::FieldStats.new(name: "numeric-with-unknown")
    field_stats, number_data = generate_data_with { Faker::Number.within(range: 1.0..100.0) }

    unknown_count = 20
    unknown_count.times do
      field_stats.update("unknown")
    end

    refute(field_stats.field_type_determined?)

    assert_equal(unknown_count, field_stats.unknown_count)
    assert_equal(unknown_count + number_data.size, field_stats.total_count)

    expected_percent = (unknown_count.to_f / (unknown_count + number_data.size)) * 100.0

    assert_in_epsilon(expected_percent, field_stats.unknown_percent)
  end

  def test_resolves_type_automatically
    field_stats = ::FlatKit::FieldStats.new(name: "numeric-autoresolve", guess_threshold: 101)
    field_stats, _i = generate_data_with(stats: field_stats) { Faker::Number.within(range: 1.0..100.0) }

    refute(field_stats.field_type_determined?)
    field_stats, _i = generate_data_with(stats: field_stats) { Faker::Number.within(range: 200.0..300.0) }

    assert(field_stats.field_type_determined?)
  end

  def test_resolves_integer_appropriately_with_mixed_data
    field_stats = ::FlatKit::FieldStats.new(name: "numeric-integer", guess_threshold: 100)
    field_stats, _i = generate_data_with(count: 40, stats: field_stats) { Faker::Number.within(range: 0..1).to_s }
    field_stats, _i = generate_data_with(count: 70, stats: field_stats) { Faker::Number.within(range: 0..200).to_s }

    assert_equal(::FlatKit::FieldType::IntegerType, field_stats.field_type)
  end

  def test_resolves_boolean_appropriately_with_mixed_data
    field_stats = ::FlatKit::FieldStats.new(name: "numeric-integer", guess_threshold: 100)
    field_stats, _i = generate_data_with(count: 70, stats: field_stats) { Faker::Boolean.boolean.to_s }
    field_stats, _i = generate_data_with(count: 40, stats: field_stats) { Faker::Number.within(range: 0..200).to_s }

    assert_equal(::FlatKit::FieldType::BooleanType, field_stats.field_type)
  end

  def test_resolves_string_appropriately_with_mixed_data
    field_stats = ::FlatKit::FieldStats.new(name: "string", guess_threshold: 100)
    field_stats, _i = generate_data_with(count: 61, stats: field_stats) { Faker::Color.name.to_s }
    field_stats, _i = generate_data_with(count: 59, stats: field_stats) { Faker::Number.within(range: 0..200).to_s }

    assert_equal(::FlatKit::FieldType::StringType, field_stats.field_type)

    assert_equal(120, field_stats.count)
    assert_equal(0, field_stats.unknown_count)
    assert_equal(0, field_stats.null_count)
  end
end
