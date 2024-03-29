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
        parser.parse(argv)
      end

      if opts[:log_given] then
        ::FlatKit.log_to(opts[:log])
      end

      if opts[:verbose] then
        ::FlatKit.logger.level = :debug
      else
        ::FlatKit.logger.level = :info
      end

      ::FlatKit.logger.debug opts
      ::FlatKit.logger.debug argv

      command_name  = argv.shift
      if command_name.nil? || command_name.downcase == "help" then
        parser.educate
        exit 0
      end

      command_klass = FlatKit::Command.for(command_name)
      if command_klass.nil? then
        $stdout.puts "ERROR: Unknown command '#{command_name}'"
        parser.educate
        exit 0
      end

      command       = command_klass.new(argv: argv, logger: ::FlatKit.logger, env: env)
      command.call
    end
  end
end
