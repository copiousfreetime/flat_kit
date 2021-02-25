module FlatKit
  class FieldType
    class UnknownType < FieldType

      REGEX = %r{\A(na|n/a|unk|unknown)\Z}i

      def self.matches?(data)
        return false unless data.kind_of?(String)
        return true if data.length == 0
        return REGEX.match?(data)
      end

    end
  end
end
