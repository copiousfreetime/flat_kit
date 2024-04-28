module FlatKit
  class Command
    class Stats < ::FlatKit::Command

      def self.name
        "stats"
      end

      def self.description
        "Collect and report stats on the inputfile"
      end

      def self.parser
        ::Optimist::Parser.new do
          banner "#{Sort.description}"
          banner ""

          banner <<~BANNER
          Given an input file collect basic statistics.

          The statistics can vary based upon the datatype of the field.

          Numeric fields will report the basic count, min, max, mean, standard deviation and sum.
          Non-numeric fields that are comparable, like dates, will report count, min and max.
          Other non-numeric fields will only report the count.

          Adding --cardinality will report the count, and frequency of distinct values in the result.
          This will allow for reporting the median value.

          The fields upon which stats are collected may be selected with the --fields parameter.
          By default statistics are collected on all fields.

          The flatfile type(s) will be automatically determined by the file name.

          The output can be dumped as a CSV, JSON or a a formated ascii table.

          BANNER

          banner <<~USAGE

          Usage:
            fk stats --everything file.json
            fk stats --select surname,given_name file.csv
            fk stats --select surname,given_name --output-format json file.csv > stats.json
            fk stats --select field1,field2 --output-format json input.csv
            fk stats --select field1 file.json.gz -o stats.csv
            gunzip -c file.json.gz | fk stats --input-format json --output-format text

          USAGE

          banner <<~OPTIONS

          Options:

          OPTIONS

          opt :output, "Send the output to the given path instead of standard out.", default: "<stdout>"
          opt :input_format, "Input format, csv or json", default: "auto", short: :none
          opt :output_format, "Output format, csv or json", default: "auto", short: :none
          opt :select, "The comma separted list of field(s) to report stats on", required: false, type: :string
          opt :everything, "Show all statistics that are possible", default: false
          opt :cardinality, "Show the cardinality of the fields, this requires additional memory", default: false
        end
      end

      def parse
        parser = self.class.parser
        ::Optimist::with_standard_exception_handling(parser) do
          begin
            opts = parser.parse(argv)
            fields = ::FlatKit::Stats::AllFields
            fields = CSV.parse_line(opts[:select]) if opts[:select]

            stats = [FieldStats::CORE_STATS]
            stats << FieldStats::CARDINALITY_STATS if opts[:cardinality] || opts[:everything]

            paths = parser.leftovers
            raise ::Optimist::CommandlineError, "1 and only 1 input file is allowed" if paths.size > 1

            path = paths.first || "-" # default to stdin
            @stats = ::FlatKit::Stats.new(input: path, input_fallback: opts[:input_format],
                                         output: opts[:output], output_fallback: opts[:output_format],
                                         fields_to_stat: fields, stats_to_collect: stats)
          rescue ::FlatKit::Error => e
            raise ::Optimist::CommandlineError, e.message
          end
        end
      end

      def call
        @stats.call
      end
    end
  end
end
