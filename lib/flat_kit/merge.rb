module FlatKit
  class Merge
    attr_reader :compare_fields
    attr_reader :inputs
    attr_reader :output
    attr_reader :logger
    attr_reader :output_format

    def initialize(inputs:, compare_fields:, input_format: :auto,
                   output: $stdout, output_format: :auto,
                   logger: FlatKit.logger)

      @compare_fields = compare_fields.map{ |k| k.to_s }
      @inputs         = inputs
      @input_format   = input_format
      @output         = output
      @output_format  = ::FlatKit::Format.for(output_format)

      @readers = Array.new.tap do |a|
        @inputs.each do |i|
          format = ::FlatKit::Format.for(i)
          reader = format.reader.new(source: i, compare_fields: @compare_fields)
        end
      end

      @readers = inputs.map { |r|
        format 
        FlatKit::Reader.new(source: i, compare_fields: compare_fields, format: input_format) 
      }

      @output_format = output_format
      format = ::FlatKit::Format.for(output)
      @writer = format.writer.new(destination: output)

      @logger = logger
    end

  end
end
__END__
    def call

compare_fields = %w[ ms t ]
format = ::FlatKit::Format.for('json')
readers = ARGV.map do |path|
  format.reader.new(source: path, compare_fields: compare_fields)
end

writer = format.writer.new(destination: "output.jsonl.gz")
tree = ::FlatKit::MergeTree.new(readers)
count = 0
tree.each do |record|
  writer.write(record)
  #puts "#{"%6s" % record['ms']} #{record['t']}"
  count += 1
end
writer.close

read_count = 0
tree.readers.each do |r|
  $stderr.puts "Reader #{r.source} count #{r.count}"
  read_count += r.count
end
$stde
    end
  end
end
