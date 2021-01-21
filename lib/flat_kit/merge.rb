module FlatKit
  class Merge
    attr_reader :compare_keys
    attr_reader :inputs
    attr_reader :output
    attr_reader :logger
    attr_reader :output_format

    def initialize(inputs:, compare_keys:, input_format: :auto,
                   output: $stdout, output_format: :auto,
                   logger: FlatKit.logger)

      @compare_keys = compare_keys.map{ |k| k.to_s }
      @inputs       = inputs
      @input_format = input_format

      #@readers = inputs.map { |r| FlatKit::Reader.new(source: i, compare_keys: compare_keys, format: input_format) }

      @output_format = output_format
      @output = FlatKit::Output.from(output)
      #@writer = FlatKit::Writer.new(destination: output, format: output_format)

      @logger = logger
    end

    def call

    end
  end
end
