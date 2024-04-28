require "csv"
module FlatKit
  class Command
    class Sort < ::FlatKit::Command

      def self.name
        "sort"
      end

      def self.description
        "Sort a given file by a set of fields."
      end

      def self.parser
        ::Optimist::Parser.new do
          banner "#{Sort.description}"
          banner ""

          banner <<~BANNER
          Given an input file and a sort key, order the records in that file by that
          key. If no input file is given the stdin is assumed. If no output file
          is given then stdout is assumed.

          The --key parameter is required, and it must be a comma separated list
          of field nams on the input on which to use as the sort key for the merge
          process.

          There must also be only 1 input files.

          The flatfile type(s) will be automatically determined by the file name.
          If the output is not a file, but to stdout then the output type will
          be the same as the first input file, or it can be specified as a commandline
          switch.

          BANNER

          banner <<~USAGE

          Usage:
            fk sort --key surname,given_name file.csv > sorted.csv
            fk sort --key surname,given_name --output-format json file.csv > sorted.json
            fk sort --key field1,field2 --output-format json input.csv | gzip -c > sorted.json.gz
            fk sort --key field1 file.json.gz -o sorted.json.gz
            gunzip -c file.json.gz | fk sort --key field1 --input-format json --output-format json > gzip -c sorted.json.gz

          USAGE

          banner <<~OPTIONS

          Options:

          OPTIONS

          opt :output, "Send the output to the given path instead of standard out.", default: "<stdout>"
          opt :input_format, "Input format, csv or json", default: "auto", short: :none
          opt :output_format, "Output format, csv or json", default: "auto", short: :none
          opt :key, "The comma separted list of field(s) to use for sorting the input", required: true, type: :string
        end
      end

      attr_reader :compare_keys
      attr_reader :reader
      attr_reader :sort

      def parse
        parser = self.class.parser
        ::Optimist::with_standard_exception_handling(parser) do
          begin
            @opts = parser.parse(argv)
            @compare_keys = CSV.parse_line(opts[:key])
            paths = parser.leftovers
            raise ::Optimist::CommandlineError, "1 and only 1 input file is allowed" if paths.size > 1
            path = paths.first || "-" # default to stdin
            @sort = ::FlatKit::Sort.new(input: path, input_fallback: opts[:input_format],
                                        output: opts[:output], output_fallback: opts[:output_format],
                                        compare_fields: @compare_keys)
          rescue ::FlatKit::Error => e
            raise ::Optimist::CommandlineError, e.message
          end
        end
      end

      def call
        sort.call
      end
    end
  end
end
