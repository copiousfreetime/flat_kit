# frozen_string_literal: true

module FlatKit
  class Command
    # Internal: The implementation of the cat command.
    #
    # TODO: Implement the --flatten commandline switch
    class Cat < ::FlatKit::Command
      def self.name
        "cat"
      end

      def self.description
        "Concatenate files together that have the same structure."
      end

      def self.parser
        ::Optimist::Parser.new do
          banner Cat.description.to_s
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

            NOTE: If converting from JSON to CSV and the input JSON does not have
                  every possible field on ever record, then the output csv iwll
                  be corrupted.

                  In this case the input json should be fed through 'flatten' first
                  or use the '--flatten' flag which will require an additional pass
                  through the input to gather all the fields
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
        parser = self.class.parser
        ::Optimist.with_standard_exception_handling(parser) do
          @opts = parser.parse(argv)
          paths = parser.leftovers

          @readers = ::FlatKit::Reader.create_readers_from_paths(paths: paths, fallback: opts[:input_format])
          @writer  = ::FlatKit::Writer.create_writer_from_path(path: opts[:output], fallback: opts[:output_format],
                                                               reader_format: @readers.first.format_name)
        rescue ::FlatKit::Error => e
          raise ::Optimist::CommandlineError, e.message
        end
      end

      def call
        total = 0
        readers.each do |r|
          logger.info "cat #{r.source} to #{writer.destination}"
          r.each do |record|
            writer.write(record)
            total += 1
          end
          logger.info "read #{r.count} records from #{r.source}"
        end
        writer.close
        logger.debug "processed #{writer.count} records"
        logger.debug "read #{total} records"
      end
    end
  end
end
