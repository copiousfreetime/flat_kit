require_relative '../test_helper'

module TestFieldType
  class TestGuessType < ::Minitest::Test

    def test_guess_type_should_not_match_anything
      refute(FlatKit::FieldType::GuessType.matches?(nil))
    end

    def test_guess_type_returns_coerce_failure
      assert_equal(::FlatKit::FieldType::CoerceFailure, ::FlatKit::FieldType::GuessType.coerce(nil))
    end
  end
end
