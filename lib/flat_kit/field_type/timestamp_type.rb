module FlatKit
  class FieldType
    class TimestampType < FieldType
      def self.parse_formats
        @timestamp_formats ||= [
          "%Y-%m-%d %H:%M:%S.%NZ",
          "%Y-%m-%d %H:%M:%S.%N",
          "%Y-%m-%dT%H:%M:%S.%N%z", # w3cdtf
          "%Y-%m-%d %H:%M:%S",
          "%Y-%m-%dT%H:%M:%S%z",
          "%Y-%m-%dT%H:%M:%SZ", 
          "%Y%m%dT%H%M%S",
          "%a, %d %b %Y %H:%M:%S %z", # rfc2822, httpdate
        ].freeze
      end

      def self.type_name
        "timestamp"
      end

      def self.matches?(data)
        coerced = coerce(data)
        return coerced.kind_of?(Time)
      end

      def self.coerce(data)
        case data
        when Time
          data
        when String
          parse_formats.each do |format|
            begin
              coerced_data = Time.strptime(data, format).utc
              return coerced_data
            rescue => _
              # do nothing
            end
          end
          CoerceFailure
        else
          CoerceFailure
        end
      end
    end
  end
end
