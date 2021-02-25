require_relative '../test_helper'

module TestFieldType
  class TestNullType < ::Minitest::Test

    def test_null
      assert(FlatKit::FieldType::NullType.matches?(nil))
    end


    def test_nully_items
      [ "null", "NULL", "nil", "\\N" ].each do |s|
        assert(FlatKit::FieldType::NullType.matches?(s), "#{s} should be null")
      end
    end

    def test_other_class_does_not_match
      [ 42, Object.new, true, false ].each do |x|
        refute(FlatKit::FieldType::NullType.matches?(x), "#{x} should not be == null")
      end
    end
  end
end
