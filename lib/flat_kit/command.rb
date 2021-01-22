module FlatKit
  class Command
    extend DescendantTracker

    attr_reader :argv
    attr_reader :env
    attr_reader :logger
    attr_reader :opts
    attr_reader :readers
    attr_reader :writer

    def self.name
      raise NotImplementedError, "#{self.class} must implement #{self.class}.name"
    end

    def self.description
      raise NotImplementedError, "#{self.class} must implement #{self.class}.description"
    end

    def self.parser
      raise NotImplementedError, "#{self.class} must implement #{self.class}.parser"
    end

    def self.names
      children.map { |c| c.name }
    end

    def self.for(name)
      children.find do |child_klass|
        child_klass.name == name
      end
    end

    def initialize(argv:, logger: ::FlatKit.logger, env: ENV)
      @argv = argv
      @env = env
      @logger = logger
      parse
    end

    def parse
      parser = self.class.parser
      ::Optimist::with_standard_exception_handling(parser) do
        @opts = parser.parse(argv)
        paths = parser.leftovers
        @readers = create_readers_from_paths(paths: paths, fallback: opts[:input_format])
        @writer  = create_writer_from_path(path: opts[:output], fallback: opts[:output_format],
                                           reader_format: @readers.first.format_name)
      end
    end

    def call
      raise NotImplementedError, "#{self.class} must implement #{self.class}.description"
    end

    def format_for(path:, fallback: "auto")
      # test by path
      format = ::FlatKit::Format.for(path)
      return format unless format.nil?

      # now try the fallback
      format = ::FlatKit::Format.for(fallback)
      return format unless format.nil?

      # well, that's an error
      raise ::FlatKit::Error::UnknownFormat, "Unable to figure out format for '#{path}' with fallback '#{fallback}'"
    end

    # Should ::Optimist::with_standard_exception_handling(parser) block
    def create_readers_from_paths(paths:, fallback:)
      if paths.empty? then
        paths << "-"
      end

      Array.new.tap do |a|
        paths.each do |path|
          begin
            format = format_for(path: path, fallback: fallback)
            a << format.reader.new(source: path)
          rescue StandardError => e
            raise ::Optimist::CommandlineError, e.message
          end
        end
      end
    end

    def create_writer_from_path(path:, fallback:, reader_format:)
      fallback = reader_format if fallback == "auto"
      format   = format_for(path: path, fallback: fallback)
      format.writer.new(destination: path)
    end
  end
end

require 'flat_kit/command/cat'
require 'flat_kit/command/merge'
