# frozen_string_literal: true

module FlatKit
  class FieldType
    # Internal: Unknown type, this is what we use for unknown values in the data
    #
    class UnknownType < FieldType
      REGEX = %r{\A(na|n/a|unk|unknown)\Z}i.freeze

      def self.type_name
        "unknown"
      end

      def self.matches?(data)
        return false unless data.is_a?(String)
        return true if data.empty?

        REGEX.match?(data)
      end

      def self.coerce(data)
        return data if REGEX.match?(data)

        CoerceFailure
      rescue StandardError
        CoerceFailure
      end
    end
  end
end
