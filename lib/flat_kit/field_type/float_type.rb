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
          rescue ArgumentError => _
            false
          end
        else
          false
        end
      end

      def self.coerce(data)
        Float(data)
      rescue TypeError => _
        CoerceFailure
      rescue ArgumentError => _
        CoerceFailure
      end
    end
  end
end
