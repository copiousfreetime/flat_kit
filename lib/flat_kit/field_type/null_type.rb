# frozen_string_literal: true

module FlatKit
  class FieldType
    # Internal: Class reprepseting the null type and coercian to it.
    #
    class NullType < FieldType
      REGEX = Regexp.union(/\A(null|nil)\Z/i, /\A\\N\Z/)

      def self.type_name
        "null"
      end

      def self.matches?(data)
        case data
        when nil
          true
        when String
          REGEX.match?(data)
        else
          false
        end
      end

      def self.coerce(data)
        case data
        when nil
          data
        when String
          return nil if REGEX.match?(data)

          CoerceFailure
        else
          CoerceFailure
        end
      end
    end
  end
end
