module FlatKit
  class FieldType
    # Representing the type of data which only includes data up to the day
    # resolution
    class DateType < FieldType

      # https://en.wikipedia.org/wiki/Date_format_by_country
      # %Y   4 digit year
      # %y   2 didigt year (%Y mod 100) (00..99)
      # %m   month of year zero padded
      # %-m  month of year no-padding
      # %B   Full month name
      # %b   Abbreviated month name
      # %^b  uppercased month name
      # %d   day of month zero padded
      # %-d  day of moneth not padded
      # %e   day of month blank padded
      # %j   day of year zero padded

      # parse formats are not the same as print formats as parsing does not deal
      # with flags and widths
      def self.parse_formats
        @parse_formats ||= [
          # YMD formats
          "%Y-%m-%d",
          "%Y%m%d",
          "%Y/%m/%d",
          "%Y.%m.%d",
          "%Y.%m.%d.",
          "%Y %m %d.",
          "%Y %b %d",
          "%Y %B %d",
          "%Y-%m%d",
          "%Y. %m. %d.",
          "%Y, %d %B",
          "%Y, %d %b",

          "%y.%m.%d.",
          "%y.%m.%d",
          "%y/%m/%d",

          # DMY formats
          "%d %B %Y",
          "%d %b %Y",
          "%d%m%y",
          "%d-%B-%Y",
          "%d/%b/%Y",
          "%d-%b-%Y",
          "%d-%m-%Y",
          "%d-%m-%y",
          "%d. %B %Y",
          "%d. %B %Y.",
          "%d. %m. %Y",
          "%d. %m. %Y.",
          "%d.%B.%Y",
          "%d.%B.%y",
          "%d.%b.%Y",
          "%d.%b.%y",
          "%d.%m.%Y",
          "%d.%m.%Y.",
          "%d.%m.%y",
          "%d/%m %Y",
          "%d/%m-%y",
          "%d/%m/%Y",
          "%d/%m/%y",

          # MDY formats
          "%m/%d/%y",
          "%m/%d/%Y",
          "%m-%d-%Y",
          "%b-%d-%Y",
          "%B %d. %Y",
          "%B %d, %Y",
          "%B-%d-%Y",
          "%B/%d/%Y",

          # other formats
          "%Y-%j",
          "%Y%m",
          "%Y-%m",
          "%Y %m",
          "%a %b %d %Y"

       ]

      end

      def self.known_formats
        @known_formats ||= [
          # YMD formats
          "%Y-%m-%d",
          "%Y%m%d",
          "%Y/%m/%d",
          "%Y.%m.%d",
          "%Y.%m.%d.",
          "%Y %m %d.",
          "%Y %b %d",
          "%Y %b %-d",
          "%Y %B %-d",
          "%Y %B %d",
          "%Y-%m%d",
          "%Y. %m. %-d.",
          "%Y. %m. %d.",
          "%Y.%-m.%-d.",
          "%Y.%-m.%-d",
          "%Y, %d %B",
          "%Y, %d %b",

          "%y.%-m.%-d",
          "%y.%-m.%-d.",
          "%y.%m.%d.",
          "%y.%m.%d",
          "%y/%m/%d",

          # DMY formats
          "%-d %b %Y",
          "%-d %B %Y",
          "%-d-%-m-%Y",
          "%-d. %-m. %Y",
          "%-d. %-m. %Y.",
          "%-d. %B %Y",
          "%-d. %B %Y.",
          "%-d.%-m.%Y",
          "%-d.%-m.%Y.",
          "%-d.%m.%Y.",
          "%-d.%m.%Y",
          "%-d.%b.%Y",
          "%-d.%B.%Y",
          "%-d/%-m %Y",
          "%-d/%-m/%Y",
          "%d %B %Y",
          "%d %b %Y",
          "%d-%m-%Y",
          "%d-%b-%Y",
          "%d-%B-%Y",
          "%d.%m.%Y",
          "%d/%m %Y",
          "%d/%m/%Y",

          "%-d.%b.%y",
          "%-d.%B.%y",
          "%-d.%-m.%y",
          "%-d/%-m-%y",
          "%-d/%-m/%y",
          "%d/%m/%y",
          "%d-%m-%y",
          "%d.%m.%y",
          "%d%m%y",

          # MDY formats
          "%-m/%-d/%Y",
          "%m/%d/%Y",
          "%m-%d-%Y",
          "%b-%d-%Y",
          "%B %-d, %Y",
          "%B %-d. %Y",
          "%B %d, %Y",
          "%B-%d-%Y",
          "%B/%d/%Y",

          "%-m/%-d/%y",

          # other formats
          "%Y-%j",
          "%Y%m",
          "%Y-%m",
          "%Y %m",
        ]
      end

      def self.type_name
        "date"
      end

      def self.matches?(data)
        coerced = coerce(data)
        return coerced.kind_of?(Date)
      end

      def self.coerce(data)
        case data
        when DateTime
          CoerceFailure
        when Date
          data
        when String
          coerced_data = CoerceFailure
          parse_formats.each do |format|
            begin
              coerced_data = Date.strptime(data, format)
              break
            rescue => _
              false
            end
          end
          coerced_data
        else
          CoerceFailure
        end
      end
    end
  end
end


__END__

