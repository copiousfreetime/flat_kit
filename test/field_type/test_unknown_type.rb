require_relative '../test_helper'

module TestFieldType
  class TestUnknownType < ::Minitest::Test

    def test_unknown_items
      [ 'na', 'n/a', 'unk', 'unknown', ''].each do |u|
        assert(FlatKit::FieldType::UnknownType.matches?(u), "#{u} should be unknown")
      end
    end

    def test_other_class_does_not_match
      [ 42, Object.new, true, false ].each do |x|
        refute(FlatKit::FieldType::UnknownType.matches?(x), "#{x} should not unknown ")
      end
    end
  end
end
