# frozen_string_literal: true

module FlatKit
  class FieldType
    # Internal: Implemenation of the boolean type and coercion to the type
    #
    class BooleanType < FieldType
      TRUTHY_REGEX = /\A(true|t|1|yes|y|on)\Z/i
      FALSEY_REGEX = /\A(false|f|0|no|n|off)\Z/i
      REGEX        = Regexp.union(TRUTHY_REGEX, FALSEY_REGEX)

      def self.type_name
        "boolean"
      end

      def self.matches?(data)
        case data
        when TrueClass, FalseClass
          true
        when String
          REGEX.match?(data)
        when Integer
          return true if data.zero?
          return true if data == 1

          false
        else
          false
        end
      end

      def self.coerce(data)
        case data
        when TrueClass
          true
        when FalseClass
          false
        when Numeric
          return false if data.zero?
          return true  if data == 1

          CoerceFailure
        when String
          return true  if TRUTHY_REGEX.match?(data)
          return false if FALSEY_REGEX.match?(data)

          CoerceFailure
        end
      end
    end
  end
end
