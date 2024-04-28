require_relative "../test_helper"

module TestFieldType
  class TestFloatType < ::Minitest::Test
    def test_float_matches
      assert(FlatKit::FieldType::FloatType.matches?(42.0))
      assert(FlatKit::FieldType::FloatType.matches?(42.1))
    end

    def test_integer_does_not_match
      refute(FlatKit::FieldType::FloatType.matches?(42))
    end

    def test_string_of_digits_does_not_match
      refute(FlatKit::FieldType::FloatType.matches?("42"))
    end

    def test_string_of_digits_with_dot_matches
      assert(FlatKit::FieldType::FloatType.matches?("42.0"))
    end

    def test_string_of_leters_does_not_match
      refute(FlatKit::FieldType::FloatType.matches?("abc"))
    end

    def test_scientific_notation_matches
      assert(FlatKit::FieldType::FloatType.matches?("1e-10"))
    end

    def test_other_class_does_not_match
      refute(FlatKit::FieldType::FloatType.matches?(Object.new))
    end

    def test_integer_coerces
      assert_equal(42.0, ::FlatKit::FieldType::FloatType.coerce(42))
    end

    def test_integer_strings_coerce
      assert_equal(42.0, ::FlatKit::FieldType::FloatType.coerce("42"))
    end

    def test_float_strings_coerce
      assert_equal(42.6, ::FlatKit::FieldType::FloatType.coerce("42.6"))
    end

    def test_float_coerces
      assert_equal(42.6, ::FlatKit::FieldType::FloatType.coerce(42.6))
    end

    def test_non_numercic_do_not_coerce
      [ "eleven", nil, false, Object.new ].each do |nope|
        assert_equal(::FlatKit::FieldType::CoerceFailure, ::FlatKit::FieldType::FloatType.coerce(nope))
      end
    end
  end
end
