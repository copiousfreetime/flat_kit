module FlatKit
  class Command
    extend DescendantTracker

    attr_reader :argv
    attr_reader :env
    attr_reader :logger
    attr_reader :opts

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
      @opts = ::Optimist::with_standard_exception_handling(parser) do
        o = parser.parse(argv)
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
  end
end

require 'flat_kit/command/cat'
