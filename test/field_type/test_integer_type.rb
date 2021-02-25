require_relative '../test_helper'

module TestFieldType
  class TestIntegerType < ::Minitest::Test
    def test_matches_integer
      assert(FlatKit::FieldType::IntegerType.matches?(42))
    end

    def test_matches_negative_integer
      assert(FlatKit::FieldType::IntegerType.matches?("-42"))
    end

    def test_float_does_not_match
      refute(FlatKit::FieldType::IntegerType.matches?(42.0))
    end

    def test_string_of_digits_matches
      assert(FlatKit::FieldType::IntegerType.matches?("42"))
    end

    def test_string_with_some_digiets_does_not_match
      refute(FlatKit::FieldType::IntegerType.matches?("42.0"))
      refute(FlatKit::FieldType::IntegerType.matches?("abc"))
    end

    def test_other_class_does_not_match
      refute(FlatKit::FieldType::IntegerType.matches?(Object.new))
    end
  end
end
