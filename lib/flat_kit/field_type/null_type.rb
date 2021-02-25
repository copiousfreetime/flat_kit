module FlatKit
  class FieldType
    class NullType < FieldType

      REGEX = Regexp.union(/\A(null|nil)\Z/i, /\A\\N\Z/)

      def self.matches?(data)
        case data
        when nil
          true
        when String
          REGEX.match?(data)
        else
          false
        end
      end

    end
  end
end
