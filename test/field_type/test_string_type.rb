# frozen_string_literal: true

require_relative "../test_helper"

module TestFieldType
  class TestStringType < ::Minitest::Test
    def test_string_will_not_match_non_string_data
      [42, false, true, 12.5, Object.new].each do |o|
        refute(FlatKit::FieldType::StringType.matches?(o))
      end
    end

    def test_string_type_returns_coerce_failures
      [BasicObject.new].each do |o|
        assert_equal(::FlatKit::FieldType::CoerceFailure, ::FlatKit::FieldType::StringType.coerce(o))
      end
    end
  end
end
