# frozen_string_literal: true

module FlatKit
  class FieldType
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

          begin
            Float(data)
            true
          rescue ArgumentError => _e
            false
          end
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
    end
  end
end
