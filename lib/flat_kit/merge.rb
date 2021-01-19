module FlatKit
  class Merge
    attr_reader :input_paths
    attr_reader :inputs
    attr_reader :key
    attr_reader :output_path
    attr_reader :output
    attr_reader :logger
    attr_reader :output_format

    def initialize(inputs:, key:, output: $stdout,
                   logger: FlatKit.logger, output_format: :json)
      @inputs = nil
      @input_paths = nil

      @output = nil
      @output_path = nil

      @key = key
      @logger = logger
      @output_format = output_format

      #setup_input(inputs)
      setup_output(output)
    end

    def call

    end

    private

    # setup the output, the output is going to go to stderr or to a file, what
    # is passed in could be a string
    def setup_output(out_thing)
      case out_thing
      when File
        @output_path = out_thing.path
        @output = out_thing
      when IO
        @output_path = out_thing.inspect
        @output = out_thing
      when String
        if out_thing  == "-" then
          @output_path = $stdout.inspect
          @output = $stdout
        else
          @output_path = out_thing
          p = Pathname.new(out_thing)
          p.dirname.mkpath
          @output = p.open("w")
        end
      when Pathname
        @output_path = out_thing.to_s
        out_thing.dirname.mkpath
        @output = out_thing.open("w")
      else
        raise FlatKit::Error, "Unable to handle output of #{out_thing.class} : #{out_thing.inspect}"
      end
    end
  end
end
