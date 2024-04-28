# frozen_string_literal: true

require_relative "../test_helper"

module TestFieldType
  class TestDateType < ::Minitest::Test
    def test_time_does_not_match
      refute(FlatKit::FieldType::DateType.matches?(Time.now))
    end

    def test_date
      assert(FlatKit::FieldType::DateType.matches?(Date.today))
    end

    def test_datetime_does_not_match
      refute(FlatKit::FieldType::DateType.matches?(DateTime.now))
    end

    def test_formats
      formats = ::FlatKit::FieldType::DateType.parse_formats

      assert_equal(formats.size, formats.sort.uniq.size)

      formats.each do |df|
        s = Time.now.strftime("#{df}")
        assert(FlatKit::FieldType::DateType.matches?(s), "#{s} should match date")
      end
    end

    def test_other_class_does_not_match
      [42, Object.new, true, false].each do |x|
        refute(FlatKit::FieldType::DateType.matches?(x), "#{x} should not be date")
      end
    end

    def test_N_number_does_not_match
      x = "N89362"
      refute(FlatKit::FieldType::DateType.matches?(x), "#{x} should not be date")
    end

    def test_coerce
      formats = ::FlatKit::FieldType::DateType.parse_formats

      formats.each do |df|
        s = Time.now.strftime("#{df}")
        assert_instance_of(Date, FlatKit::FieldType::DateType.coerce(s), "#{s} should convert to date")
      end
    end

    def test_date_coerce_does_not_passthrough_time
      t = Time.now
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::DateType.coerce(t))
    end

    def test_date_coerce_passthrough_date
      t = Date.today
      assert_equal(t, FlatKit::FieldType::DateType.coerce(t))
    end

    def test_date_coerce_does_not_passthrough_datetime
      t = DateTime.now
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::DateType.coerce(t))
    end

    def test_number_coerce_failure
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::DateType.coerce(42))
    end

    def test_number_coerce_failure_bad_parse
      assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::DateType.coerce("1234 56 78 90"))
    end
  end
end
