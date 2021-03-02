require_relative '../test_helper'
require 'set'

module TestFieldType
  class TestDateTimeType < ::Minitest::Test
    def test_time
      assert(FlatKit::FieldType::DateTimeType.matches?(Time.now))
    end

    def test_date
      assert(FlatKit::FieldType::DateTimeType.matches?(Date.today))
    end

    def test_date_time
      assert(FlatKit::FieldType::DateTimeType.matches?(DateTime.now))
    end

    def day_formats
      [
        "%Y-%m-%d",
        "%d-%b-%Y",
        "%d/%b/%Y",
        "%d %b %Y",
        "%e/%b/%Y",
        "%e %b %Y",
        "%b %e %Y",
        "%b %d %Y",
        "%a %b %e %Y",
        "%a %b %d %Y"
      ]
    end

    def time_formats
      [
        "%H:%M:%S",
        "%H:%M:%S.%3N",
        "%H:%M:%S.%6N",
        "%H:%M:%S.%9N",
        "%l:%M %p",
        "%l:%M %P",
        "%H%M",
      ]
    end

    def test_formats
     assert_equal(day_formats.size, day_formats.sort.uniq.size)
     assert_equal(time_formats.size, time_formats.sort.uniq.size)

      day_formats.each do |df|
        time_formats.each do |tf|
          s = Time.now.strftime("#{df} #{tf}")
          assert(FlatKit::FieldType::DateTimeType.matches?(s), "#{s} should match datetime")
        end
      end
    end

    def test_other_class_does_not_match
      [ 42, Object.new, true, false ].each do |x|
        refute(FlatKit::FieldType::DateTimeType.matches?(x), "#{x} should not be date")
      end
    end

    def test_coercian
      day_formats.each do |df|
        time_formats.each do |tf|
          s = Time.now.strftime("#{df} #{tf}")
          assert_instance_of(DateTime, FlatKit::FieldType::DateTimeType.coerce(s), "#{s} should convert to datetime")
        end
      end
    end

    def test_date_coerce_passthrough_time
      t = Time.now
      assert_equal(t, FlatKit::FieldType::DateTimeType.coerce(t))
    end

    def test_date_coerce_passthrough_date
      t = Date.today
      assert_equal(t, FlatKit::FieldType::DateTimeType.coerce(t))
    end

    def test_date_coerce_passthrough_datetime
      t = DateTime.now
      assert_equal(t, FlatKit::FieldType::DateTimeType.coerce(t))
    end

    def test_number_coerce_failure
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::DateTimeType.coerce(42))
    end

    def test_number_coerce_failure_bad_parse
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::DateTimeType.coerce("1234 56 78 90"))
    end
  end
end
