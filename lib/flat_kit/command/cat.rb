module FlatKit
  class Command
    attr_reader :input_paths

    class Cat < ::FlatKit::Command
      def self.name
        "cat"
      end

      def self.description
        "Concatenate files together that have the same structure."
      end

      def self.parser
        ::Optimist::Parser.new do
          banner "#{Cat.description}"
          banner ""

          banner <<~BANNER
          Concatenates files that have the same field structure together into
          a single file. The files can be of different formats, but must have
          the same fields and names.

          This is probably most easily usable as a way to convert CSV to JSON
          and vice versa.

          The flatfile type(s) will be automatically determined by the file name.
          If the inputs or output is not a file, but from stdin or stdout then
          the input and output types must be specified.
          BANNER

          banner <<~USAGE

          Usage:
            fk cat file1.csv file2.csv > combinded.csv
            fk cat --output-format json file1.csv
            fk cat file1.csv.gzip -o file2.json.gzip
            fk cat file1.csv.gzip --output-format json | gzip -c > file1.jsonl.gz

          USAGE

          banner <<~OPTIONS

          Options:

          OPTIONS

          opt :output, "Send the output to the given path instead of standard out.", default: "<stdout>"
          opt :input_format, "Input format, csv or json", default: "auto", short: :none
          opt :output_format, "Output format, csv or json", default: "auto", short: :none
        end
      end

      def parse
        require 'byebug'
        parser = self.class.parser
        ::Optimist::with_standard_exception_handling(parser) do
          @opts = parser.parse(argv)
          @input_paths = parser.leftovers
          if @input_paths.empty? then
            @input_paths << "-"
          end

          @readers = Array.new.tap do |a|
            @input_paths.each do |path|
              begin
                format = format_for(path: path, fallback: opts[:input_format])
                a << format.reader.new(source: path)
              rescue StandardError => e
                raise ::Optimist::CommandlineError, e.message
              end
            end
          end

          # output fallback is the first readers format
          output_fallback = opts[:output_format]
          if output_fallback == "auto" then
            output_fallback = @readers.first.format_name
          end

          output_format = format_for(path: opts[:output], fallback: output_fallback)
          @writer = output_format.writer.new(destination: opts[:output])
        end
      end

      def call
        @readers.each do |r|
          logger.info "Cat #{r.source} to #{@writer.destination}"
          r.each do |record|
            @writer.write(record)
          end
        end
        @writer.close
      end
    end
  end
end
