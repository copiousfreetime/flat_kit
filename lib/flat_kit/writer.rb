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

    def initialize(destination:)
      @destination = destination
    end

    def write(record)
      raise NotImplementedError, "#{self.class} needs to implement #write"
    end

    def close
      raise NotImplementedError, "#{self.class} needs to implement #close"
    end
  end
end
