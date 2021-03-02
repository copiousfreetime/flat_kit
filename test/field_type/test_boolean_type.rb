require_relative '../test_helper'

module TestFieldType
  class TestBooleanType < ::Minitest::Test
    def truthy_items
      t = %w[ yes Y true t 1 y ]
      t << 1
    end

    def falsey_items
      f = %w[ no n false f 0 N ]
      f << 0
    end

    def test_true
      assert(FlatKit::FieldType::BooleanType.matches?(true))
    end

    def test_false
      assert(FlatKit::FieldType::BooleanType.matches?(false))
    end

    def test_truthy_items
      truthy_items.each do |s|
        assert(FlatKit::FieldType::BooleanType.matches?(s), "#{s} should be boolean")
      end
    end

    def test_falsey_items
      falsey_items.each do |s|
        assert(FlatKit::FieldType::BooleanType.matches?(s), "#{s} should be boolean")
      end
    end

    def test_other_class_does_not_match
      refute(FlatKit::FieldType::BooleanType.matches?(Object.new))
    end

    def test_coerces_falsey_to_boolean
      falsey_items.each do |t|
        refute(FlatKit::FieldType::BooleanType.coerce(t))
      end
    end

    def test_true_is_truthy
      assert(FlatKit::FieldType::BooleanType.coerce(true))
    end

    def test_false_is_falsey
      refute(FlatKit::FieldType::BooleanType.coerce(false))
    end

    def test_0_is_false
      refute(FlatKit::FieldType::BooleanType.coerce(0))
    end

    def test_1_is_false
      assert(FlatKit::FieldType::BooleanType.coerce(1))
    end

    def test_42_is_false
      assert(FlatKit::FieldType::BooleanType.coerce(42.0))
    end
  end
end
