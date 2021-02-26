module FlatKit
  class FieldType
    class DateTimeType < FieldType

      def self.matches?(data)
        case data
        when Date
          true
        when Time
          true
        when DateTime
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
    end
  end
end
