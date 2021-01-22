module FlatKit
  # Public: the base class for all format readers.
  #
  # A format reader needs to be able to open the appropriate file format and
  # implement Enumerable to iterate over all the records in the file format.
  #
  # If it is appropriate for the reader to be able to read from a IO object
  # directly, that needs to be supported also.
  #
  # The ::FlatKit::Reader class should never be used directly, only the reader
  # from the appropriate format should be used.
  #
  #
  # API:
  #
  #   initialize(source:, compare_fields:)
  #   each -> Yields / returns 
  #
  class Reader
    include Enumerable

    attr_reader :source
    attr_reader :compare_fields

    def initialize(source:, compare_fields: :none)
      @source = source
      @compare_fields = resolve_compare_fields(compare_fields)
    end

    def each
      raise NotImplementedError, "#{self.class} needs to implement #each"
    end

    private

    def resolve_compare_fields(value)
      return [] if value == :none
      return value
    end
  end
end
