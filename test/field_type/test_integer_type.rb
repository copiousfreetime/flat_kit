# frozen_string_literal: true

require_relative "../test_helper"

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

    def test_integer_coerces
      assert_equal(42, ::FlatKit::FieldType::IntegerType.coerce(42))
    end

    def test_integer_strings_coerce
      assert_equal(42, ::FlatKit::FieldType::IntegerType.coerce("42"))
    end

    def test_float_coerces
      assert_equal(42, ::FlatKit::FieldType::IntegerType.coerce(42.6))
    end

    def test_float_strings_do_not_coerce
      assert_equal(::FlatKit::FieldType::CoerceFailure, ::FlatKit::FieldType::IntegerType.coerce("42.6"))
    end

    def test_non_numercic_do_not_coerce
      ["eleven", nil, false, Object.new].each do |nope|
        assert_equal(::FlatKit::FieldType::CoerceFailure, ::FlatKit::FieldType::IntegerType.coerce(nope))
      end
    end
  end
end
