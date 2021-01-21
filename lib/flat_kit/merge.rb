module FlatKit
  class Merge
    attr_reader :inputs
    attr_reader :key
    attr_reader :output
    attr_reader :logger
    attr_reader :output_format

    def initialize(inputs:, key:, output: $stdout,
                   logger: FlatKit.logger, output_format: :json)
      @inputs  = inputs.map { |i| FlatKit::Input.from(i) }
      @key     = key
      @readers = @inputs.map { |i| FlatKit::Reader.for(i).new(input: i, key: key) }

      @output = FlatKit::Output.from(output)
      @output_format = output_format
      #@writer = Writer.new(output: @output, format: @output_format)
      @logger = logger
    end

    def call

    end
  end
end
