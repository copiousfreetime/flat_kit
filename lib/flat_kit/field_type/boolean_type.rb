module FlatKit
  class FieldType
    class BooleanType < FieldType

      TRUTHY_REGEX = /\A(true|t|1|yes|y|on)\Z/i
      FALSEY_REGEX = /\A(false|f|0|no|n|off)\Z/i
      REGEX        = Regexp.union(TRUTHY_REGEX, FALSEY_REGEX)

      def self.matches?(data)
        case data
        when TrueClass
          true
        when FalseClass
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
