require_relative "../test_helper"

module TestFieldType
  class TestNullType < ::Minitest::Test
    def nully_items
      ["null", "NULL", "nil", "\\N"]
    end

    def test_null
      assert(FlatKit::FieldType::NullType.matches?(nil))
    end

    def test_nully_items
      nully_items.each do |s|
        assert(FlatKit::FieldType::NullType.matches?(s), "#{s} should be null")
      end
    end

    def test_other_class_does_not_match
      [42, Object.new, true, false].each do |x|
        refute(FlatKit::FieldType::NullType.matches?(x), "#{x} should not be == null")
      end
    end

    def test_coerce_coerces_nil
      assert_nil(FlatKit::FieldType::NullType.coerce(nil))
    end

    def test_coerces_nully_items
      nully_items.each do |s|
        assert_nil(FlatKit::FieldType::NullType.coerce(s))
      end
    end

    def test_coerce_failure_non_non_nully_items
      ["whatever", 42, Object.new, true, false, Class].each do |x|
        assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::NullType.coerce(x))
      end
    end
  end
end
