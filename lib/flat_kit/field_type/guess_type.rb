module FlatKit
  class FieldType
    # GuessType is a field type where we don't know what type the field is, and
    # it needs to be guessed. This is a sentinel type that doesn't match any
    # data.
    class GuessType < FieldType
      def self.matches?(data)
        false
      end

      def self.coerce(data)
        CoerceFailure
      end
    end
  end
end
