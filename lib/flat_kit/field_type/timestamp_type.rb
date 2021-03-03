module FlatKit
  class FieldType
    class TimestampType < FieldType

      def self.time_formats
        @time_formats ||= [
          "%H:%M:%S",
          "%H:%M:%S.%3N",
          "%H:%M:%S.%6N",
          "%H:%M:%S.%9N",
          "%l:%M %p",
          "%l:%M %P",
          "%H%M",
          "%H%M%S",
          "%H:%M:%SZ",
          "%H:%M:%S%z",
          "%H:%M:%S.%3NZ",
          "%H:%M:%S.%6NZ",
          "%H:%M:%S.%9NZ",
          "%H:%M:%S.%3N%z",
          "%H:%M:%S.%6N%z",
          "%H:%M:%S.%9N%z",
        ]
      end

      def self.parse_formats
        @parse_formats ||= Array.new.tap do |a|
          a << "%Y-%m-%dT%H:%M:%S.%6N%z" # w3cdtf - which should be a method but isn't

          FieldType::DateType.parse_formats.each do |df|
            time_formats.each do |tf|
              a << "#{df} #{tf}"
            end
          end
        end
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
          # first try the well known formats
          [ :iso8601, :rfc2822, :w3cdtf, :httpdate ].each do |format|
            begin
              coerced_data = Time.send(format, data)
              return coerced_data
            rescue => _
              # do nothing
            end
          end

          # fall back to a list of generated formats
          parse_formats.each do |format|
            begin
              coerced_data = Time.strptime(data, format)
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
