require_relative "./test_helper"

module TestFieldType
  class TestFieldType < ::Minitest::Test
    def test_weight_raises_exception
      assert_raises(NotImplementedError) { ::FlatKit::FieldType.weight }
    end

    def test_best_guesses
      guesses = {
        "t"          => ::FlatKit::FieldType::BooleanType,
        "1"          => ::FlatKit::FieldType::BooleanType,
        "0"          => ::FlatKit::FieldType::BooleanType,
        "n"          => ::FlatKit::FieldType::BooleanType,
        "42"         => ::FlatKit::FieldType::IntegerType,
        "nil"        => ::FlatKit::FieldType::NullType,
        "n/a"        => ::FlatKit::FieldType::UnknownType,
        "foo"        => ::FlatKit::FieldType::StringType,
        "12.3"       => ::FlatKit::FieldType::FloatType,
        "2021-02-26" => ::FlatKit::FieldType::DateType,
        "2020-03-03T12:34:56Z" => ::FlatKit::FieldType::TimestampType,
      }

      guesses.each do |test, expected|
        assert_equal(expected, ::FlatKit::FieldType.best_guess(test), "Expected '#{test}' to be #{expected}")
      end
    end

    def test_children_exist
      assert_equal(9,::FlatKit::FieldType.children.size)
    end
  end
end
