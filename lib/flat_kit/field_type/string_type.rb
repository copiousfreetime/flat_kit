module FlatKit
  class FieldType
    # StringType is essentially a fallback - hence its lower weight than other
    # types that might have string representations.
    class StringType< FieldType
      def self.matches?(data)
        data.kind_of?(String)
      end
    end
  end
end
