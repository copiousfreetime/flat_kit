require 'optimist'
require_relative '../flat_kit/command'

module FlatKit
  class Cli
    attr_reader :options

    def initialize
      @parser = nil
    end

    def parser
      @parser ||= ::Optimist::Parser.new do
        version ::FlatKit::VERSION

        banner "fk v#{self.version}"

        banner <<~USAGE

        Usage:
          fk <command> [<args>...]
          fk [options]
        USAGE

        banner <<~OPTIONS

        Options:

        OPTIONS

        opt :verbose, "Force debug. Output lots of informtion to standard error", default: false
        opt :list, "List all the commands", default: false, short: :none
        opt :log, "Set the logger output location", default: "<stderr>", short: :none
        opt :help, "Show help message", short: :h
        opt :version, "Print version and exit", short: :none

        stop_on FlatKit::Command.names
        banner Cli.commands_banner
      end
    end

    def self.commands_banner
      sorted_commands = FlatKit::Command.children.sort_by{ |c| c.name }
      left_width = sorted_commands.map { |c| c.name.length }.sort.last
      banner = StringIO.new
      banner.puts
      banner.puts "Commands:"
      banner.puts

      sorted_commands.each do |command|
        banner.puts "  #{command.name.ljust(left_width)}    #{command.description}"
      end
      banner.string
    end

    def run(argv: ARGV, env: ENV)
      opts = ::Optimist::with_standard_exception_handling(parser) do
        o = parser.parse(argv)
      end

      # setup logger
      logger = ::FlatKit.logger

      if opts[:log_given] then
        logger = ::FlatKit::Logger.for_path(opts[:log])
      end

      if opts[:verbose] then
        logger.level = :debug
      else
        logger.level = :info
      end

      logger.debug opts
      logger.debug argv

      command_name  = argv.shift
      command_klass = FlatKit::Command.for(command_name)
      command       = command_klass.new(argv: argv, logger: logger, env: env)
      command.call
    end
  end
end
