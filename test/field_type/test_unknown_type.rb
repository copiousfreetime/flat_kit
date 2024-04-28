require_relative "../test_helper"

module TestFieldType
  class TestUnknownType < ::Minitest::Test
    def unknown_items
      [ "na", "n/a", "unk", "unknown"]
    end

    def test_unknown_items
      unknown_items.each do |u|
        assert(FlatKit::FieldType::UnknownType.matches?(u), "#{u} should be unknown")
      end
    end

    def test_other_class_does_not_match
      [ 42, Object.new, true, false, "whatever" ].each do |x|
        refute(FlatKit::FieldType::UnknownType.matches?(x), "#{x} should not unknown ")
      end
    end

    def test_coerce_unknown
      unknown_items.each do |u|
        assert_equal(u, FlatKit::FieldType::UnknownType.coerce(u), "#{u} should be unknown")
      end
    end

    def test_other_class_does_not_coerce
      [ 42, Object.new, true, false, "whatever" ].each do |x|
        assert_equal(::FlatKit::FieldType::CoerceFailure, FlatKit::FieldType::UnknownType.coerce(x))
      end
    end
  end
end
