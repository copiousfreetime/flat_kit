module FlatKit
  # Public: The base class for all format writers.
  #
  # A format writer will only write those Records, and on that, only those of
  # its own format.
  #
  # It must implement a #write methods takes a Record. It can convert the record
  # to one matching its own format if it whishes. But it should in any case
  # check the Record format to make sure it matches
  #
  # See the Xsv::Writer and Jsonl::Writer for examples.
  #
  class Writer
    attr_reader :destination
    attr_reader :count
    attr_reader :byte_count

    def self.create_writer_from_path(path:, fallback:, reader_format:)
      fallback = reader_format if fallback == "auto"
      format   = ::FlatKit::Format.for_with_fallback!(path: path, fallback: fallback)
      format.writer.new(destination: path)
    end

    def initialize(destination:)
      @destination = destination
      @count = 0
      @byte_count = 0
    end

    def format_name
      self.class.format_name
    end

    def write(record)
      raise NotImplementedError, "#{self.class} needs to implement #write"
    end

    def close
      raise NotImplementedError, "#{self.class} needs to implement #close"
    end
  end
end
