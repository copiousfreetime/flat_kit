# frozen_string_literal: true

require_relative "../test_helper"
require "set"

module TestFieldType
  class TestTimestampType < ::Minitest::Test
    def test_time
      assert(FlatKit::FieldType::TimestampType.matches?(Time.now))
    end

    def test_date
      refute(FlatKit::FieldType::TimestampType.matches?(Date.today))
    end

    def test_date_time
      refute(FlatKit::FieldType::TimestampType.matches?(DateTime.now))
    end

    def test_builtin_formats
      stock_formats = [
        Time.now.httpdate,
        Time.now.utc.httpdate,
        Time.now.iso8601,
        Time.now.utc.iso8601,
        Time.now.rfc2822,
        Time.now.utc.rfc2822,
      ]

      stock_formats.each do |t|
        assert(FlatKit::FieldType::TimestampType.matches?(t), "#{t} should match timestamp")
        assert_instance_of(Time, FlatKit::FieldType::TimestampType.coerce(t), "#{t} should convert to timestamp")
      end
    end

    def test_no_duplicate_formats
      parse_formats = ::FlatKit::FieldType::TimestampType.parse_formats

      assert_equal(parse_formats.size, parse_formats.sort.uniq.size)
    end

    def test_parse_formats
      parse_formats = ::FlatKit::FieldType::TimestampType.parse_formats.dup
      extra_formats = [
        "%Y-%m-%dT%H:%M:%S.%N%z",
        "%Y-%m-%d %H:%M:%S.%NZ",
        "%Y-%m-%d %H:%M:%S.%N",
        "%Y-%m-%dT%H:%M:%S.%3N%z",
        "%Y-%m-%d %H:%M:%S.%3NZ",
        "%Y-%m-%d %H:%M:%S.%3N",
        "%Y-%m-%dT%H:%M:%S.%6N%z",
        "%Y-%m-%d %H:%M:%S.%6NZ",
        "%Y-%m-%d %H:%M:%S.%6N",
        "%Y-%m-%dT%H:%M:%S.%9N%z",
        "%Y-%m-%d %H:%M:%S.%9NZ",
        "%Y-%m-%d %H:%M:%S.%9N",
      ]
      parse_formats.concat(extra_formats)

      parse_formats.each do |format|
        now = Time.now
        str = now.strftime(format)

        assert(FlatKit::FieldType::TimestampType.matches?(str), "#{str} should match timestamp")
        coerced = FlatKit::FieldType::TimestampType.coerce(str)

        assert_instance_of(Time, coerced)
      end
    end

    def test_other_class_does_not_match
      [42, Object.new, true, false].each do |x|
        refute(FlatKit::FieldType::TimestampType.matches?(x), "#{x} should not be date")
      end
    end

    def test_N_number_does_not_match
      x = "N89362"

      refute(FlatKit::FieldType::TimestampType.matches?(x), "#{x} should not be date")
    end

    def test_coerce_passthrough_time
      t = Time.now

      assert_equal(t, FlatKit::FieldType::TimestampType.coerce(t))
    end

    def test_coerce_do_not_passthrough_date
      t = Date.today

      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::TimestampType.coerce(t))
    end

    def test_date_coerce_passthrough_datetime
      t = Time.now

      assert_equal(t, FlatKit::FieldType::TimestampType.coerce(t))
    end

    def test_date_only_does_not_parse
      t = Time.now.strftime("%Y-%m-%d")

      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::TimestampType.coerce(t))
    end

    def test_number_coerce_failure
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::TimestampType.coerce(42))
    end

    def test_number_coerce_failure_bad_parse
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::TimestampType.coerce("1234 56 78 90"))
    end
  end
end
