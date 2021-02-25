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

    def test_formats
      day_formats = [
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
      assert_equal(day_formats.size, day_formats.sort.uniq.size)

      time_formats = [
        "%H:%M:%S",
        "%H:%M:%S.%3N",
        "%H:%M:%S.%6N",
        "%H:%M:%S.%9N",
        "%l:%M %p",
        "%l:%M %P",
        "%H%M",
      ]
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
  end
end
