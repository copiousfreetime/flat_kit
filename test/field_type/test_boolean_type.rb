require_relative '../test_helper'

module TestFieldType
  class TestBooleanType < ::Minitest::Test
    def test_true
      assert(FlatKit::FieldType::BooleanType.matches?(true))
    end

    def test_false
      assert(FlatKit::FieldType::BooleanType.matches?(false))
    end

    def test_truthy_items
      %w[ yes Y true t 1 y ].each do |s|
        assert(FlatKit::FieldType::BooleanType.matches?(s), "#{s} should be boolean")
      end
    end

    def test_falsey_items
      %w[ no n false f 0 ].each do |s|
        assert(FlatKit::FieldType::BooleanType.matches?(s), "#{s} should be boolean")
      end
    end

    def test_other_class_does_not_match
      refute(FlatKit::FieldType::BooleanType.matches?(Object.new))
    end
  end
end
