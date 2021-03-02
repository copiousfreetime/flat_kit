module FlatKit
  class FieldType
    class DateTimeType < FieldType

      def self.matches?(data)
        case data
        when DateTime
          true
        when Date
          true
        when Time
          true
        when String
          begin
            DateTime.parse(data)
            true
          rescue => _
            false
          end
        else
          false
        end
      end

      def self.coerce(data)
        case data
        when DateTime
          data
        when Date
          data
        when Time
          data
        when String
          begin
            DateTime.parse(data)
          rescue => _
            CoerceFailure
          end
        else
          CoerceFailure
        end
      end
    end
  end
end
