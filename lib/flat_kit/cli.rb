# frozen_string_literal: true

require "optimist"
require_relative "../flat_kit/command"

module FlatKit
  # Public: The the main entry point for the command line interface
  #
  class Cli
    attr_reader :options

    def initialize
      @parser = nil
    end

    def parser
      @parser ||= ::Optimist::Parser.new do
        version ::FlatKit::VERSION

        banner "fk v#{version}"

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
      sorted_commands = FlatKit::Command.children.sort_by(&:name)
      left_width = sorted_commands.map { |c| c.name.length }.max
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
      opts = parse_opts(argv)
      init_logging(opts)
      ::FlatKit.logger.debug(argv)

      command_name = argv.shift
      exit_if_help(command_name)

      command_klass = command_klass_or_exit(command_name)
      command = command_klass.new(argv: argv, logger: ::FlatKit.logger, env: env)
      command.call
    end

    private

    def parse_opts(argv)
      ::Optimist.with_standard_exception_handling(parser) do
        parser.parse(argv)
      end
    end

    def init_logging(opts)
      ::FlatKit.log_to(opts[:log]) if opts[:log_given]

      ::FlatKit.logger.level = opts[:verbose] ? :debug : :info

      ::FlatKit.logger.debug(opts)
    end

    def exit_if_help(command_name)
      return unless command_name.nil? || command_name.downcase == "help"

      parser.educate
      exit 0
    end

    def command_class_or_exit(command_name)
      command_klass = FlatKit::Command.for(command_name)
      return command_klass unless command_klass.nil?

      $stdout.puts "ERROR: Unknown command '#{command_name}'"
      parser.educate
      exit 0
    end
  end
end
