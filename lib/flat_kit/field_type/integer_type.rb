# frozen_string_literal: true

module FlatKit
  class FieldType
    class IntegerType < FieldType
      REGEX = /\A[-+]?\d+\Z/

      def self.type_name
        "integer"
      end

      def self.matches?(data)
        case data
        when Integer
          true
        when Float
          false
        when String
          REGEX.match?(data)
        else
          false
        end
      end

      def self.coerce(data)
        Integer(data)
      rescue TypeError => _
        CoerceFailure
      rescue ArgumentError => _
        CoerceFailure
      end
    end
  end
end
