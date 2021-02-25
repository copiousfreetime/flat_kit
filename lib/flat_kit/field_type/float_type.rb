module FlatKit
  class FieldType
    class FloatType < FieldType

      def self.matches?(data)
        case data
        when Float
          true
        when Integer
          false
        when String
          return false if IntegerType.matches?(data)
          begin
            f = Float(data)
            true
          rescue ArgumentError => _
            false
          end
        else
          false
        end
      end

    end
  end
end
