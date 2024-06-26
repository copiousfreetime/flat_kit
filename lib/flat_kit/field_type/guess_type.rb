# frozen_string_literal: true

module FlatKit
  class FieldType
    # Internal: GuessType is a field type where we don't know what type the
    # field is, and it needs to be guessed. This is a sentinel type that doesn't
    # match any data.
    #
    class GuessType < FieldType
      def self.type_name
        name
      end

      def self.matches?(*)
        false
      end

      def self.coerce(*)
        CoerceFailure
      end
    end
  end
end
