module FlatKit
  class FieldType
    class IntegerType < FieldType

      REGEX = /\A\d+\Z/

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

    end
  end
end
