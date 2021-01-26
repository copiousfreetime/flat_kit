require 'csv'
module FlatKit
  class Command
    class Merge < ::FlatKit::Command

      def self.name
        "merge"
      end

      def self.description
        "Merge sorted files together that have the same structure."
      end

      def self.parser
        ::Optimist::Parser.new do
          banner "#{Merge.description}"
          banner ""

          banner <<~BANNER
          Given a set of input files that have the same structure, and are already
          sorted by a set of keys. The Merge command will merge all those files
          into a single output file.

          The --key parameter is required, and it must be a comma separated list
          of field nams on the input on which to use as the sort key for the merge
          process.

          There must also be at least 2 input files. Merging only 1 file into an
          output file is the same as the 'cat' command.

          The flatfile type(s) will be automatically determined by the file name.
          If the output is not a file, but to stdout then the output type will
          be the same as the first input file, or it can be specified as a commandline
          switch.

          The merge will do a single pass through the input to generate the
          output.
          BANNER

          banner <<~USAGE

          Usage:
            fk merge --key surname,given_name file1.csv file2.csv > all.csv
            fk merge --key surname,given_name --output-format json file1.csv file2.csv > all.json
            fk merge --key field1,field2 --output-format json input*.csv | gzip -c > all.json.gz
            fk merge --key field12 file*.json.gz -o all.json.gz

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

      def parse
        parser = self.class.parser
        ::Optimist::with_standard_exception_handling(parser) do
          begin
            @opts = parser.parse(argv)
            @compare_keys = CSV.parse_line(opts[:key])
            paths = parser.leftovers
            raise ::Optimist::CommandlineError, "At least 2 input files are required" if paths.size < 2

            @merge = ::FlatKit::Merge.new(inputs: paths, input_fallback: opts[:input_format],
                                          compare_fields: @compare_keys,
                                          output: opts[:output], output_fallback: opts[:output_format])
          rescue ::FlatKit::Error => e
            raise ::Optimist::CommandlineError, e.message
          end
        end
      end

      def call
        @merge.call
      end
    end
  end
end
