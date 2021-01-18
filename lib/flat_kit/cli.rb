require 'optimist'
require 'flat_kit/logger'
require 'csv'

module FlatKit
  class Cli
    attr_reader :options

    def initialize
      @parser = nil
    end

    def parser
      @parser ||= ::Optimist::Parser.new do
        version "FlatKit v#{::FlatKit::VERSION}"

        usage "[options] inputfile(s)"

        opt :log, "Set the logger output location", default: "<stderr>"
        #opt :debug, "Force debug. Output lots of informtion to standard error", default: false
        opt :key, "The comma separted list of field(s) to use for sorting the input", required: true, type: :string
        opt :merge, "Merge only. The input files are assumed to be pre-sorted. If they are not sorted the output order is undefined.", default: true
        opt :output, "Send the output to the given path instead of standard out.", default: "<stdout>"
        #opt :output_format, "Output format, csv or json", default: "json"
      end
    end

    def run(argv: ARGV, env: ENV)
      opts = ::Optimist::with_standard_exception_handling(parser) do
        o = parser.parse(argv)
        raise Optimist::CommandlineError, "At least 1 input file is required" if parser.leftovers.empty?

        if !o[:output_given] then
          o[:output] = $stdout
        end
        o
      end

      # parse the key fields
      opts[:key] = CSV.parse_line(opts[:key])

      # gather the inputs
      opts[:inputs] = parser.leftovers.map { |input|
        if input == "-" then
          $stdin
        else
          input
        end
      }

      # setup logger
      logger = ::FlatKit.logger

      if opts[:log_given] then
        logger = ::FlatKit::Logger.for_path(opts[:log])
      end

      logger.debug(opts)

      merge = ::FlatKit::Merge.new(inputs: opts[:inputs], output: opts[:output],
                                   logger: logger, key: opts[:key], output_format: :json)
      merge.call
    end
  end
end
