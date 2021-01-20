module FlatKit
  class Merge
    attr_reader :inputs
    attr_reader :key
    attr_reader :output
    attr_reader :logger
    attr_reader :output_format

    def initialize(inputs:, key:, output: $stdout,
                   logger: FlatKit.logger, output_format: :json)
      @inputs = nil

      @output = FlatKit::Output.from(output)
      @output_format = output_format

      @key = key
      @logger = logger
    end

    def call

    end
  end
end
