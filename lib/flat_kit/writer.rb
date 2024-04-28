# frozen_string_literal: true

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
    attr_reader :destination, :output, :count, :last_position

    def self.create_writer_from_path(path:, fallback:, reader_format:)
      fallback = reader_format if fallback == "auto"
      format   = ::FlatKit::Format.for_with_fallback!(path: path, fallback: fallback)
      format.writer.new(destination: path)
    end

    def initialize(destination:)
      @destination = destination
      @output = ::FlatKit::Output.from(@destination)
      @count = 0
      @last_position = nil
    end

    def format_name
      self.class.format_name
    end

    def current_position
      ::FlatKit::Position.new(index: @count,       # since this hasn't been written yet its the right index
                              offset: output.tell,
                              bytesize: 0)         # nothing has been written yet
    end

    # The write method MUST return a Position object detailing the location the
    # record was written in the output stream.
    #
    def write(record)
      raise NotImplementedError, "#{self.class} needs to implement #write that returns Position"
    end

    def close
      output.close
    end
  end
end
