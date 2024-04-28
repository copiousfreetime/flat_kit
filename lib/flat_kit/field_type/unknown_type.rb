module FlatKit
  class FieldType
    class UnknownType < FieldType
      REGEX = %r{\A(na|n/a|unk|unknown)\Z}i

      def self.type_name
        "unknown"
      end

      def self.matches?(data)
        return false unless data.kind_of?(String)
        return true if data.length == 0

        return REGEX.match?(data)
      end

      def self.coerce(data)
        return data if REGEX.match?(data)

        return CoerceFailure
      rescue
        return CoerceFailure
      end
    end
  end
end
