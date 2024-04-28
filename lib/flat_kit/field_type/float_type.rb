# frozen_string_literal: true

module FlatKit
  class FieldType
    # Internal: Represeting floating point data and conversion to it
    #
    class FloatType < FieldType
      def self.type_name
        "float"
      end

      def self.matches?(data)
        case data
        when Float
          true
        when Integer
          false
        when String
          return false if IntegerType.matches?(data)

          maybe_float?(data)
        else
          false
        end
      end

      def self.coerce(data)
        Float(data)
      rescue TypeError => _e
        CoerceFailure
      rescue ArgumentError => _e
        CoerceFailure
      end

      def self.maybe_float?(data)
        Float(data)
        true
      rescue ArgumentError => _e
        false
      end
    end
  end
end
