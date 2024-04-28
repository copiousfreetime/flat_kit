# frozen_string_literal: true

module FlatKit
  class FieldType
    # StringType is essentially a fallback - hence its lower weight than other
    # types that might have string representations.
    class StringType< FieldType
      def self.type_name
        "string"
      end

      def self.matches?(data)
        data.kind_of?(String)
      end

      def self.coerce(data)
        data.to_s
      rescue => _
        CoerceFailure
      end
    end
  end
end
