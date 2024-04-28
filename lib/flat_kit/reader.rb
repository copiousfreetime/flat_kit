# frozen_string_literal: true

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

    attr_reader :source, :compare_fields

    def self.create_reader_from_path(path: "-", fallback: "auto", compare_fields: :none)
      format = ::FlatKit::Format.for_with_fallback!(path: path, fallback: fallback)
      return format.reader.new(source: path, compare_fields: compare_fields)
    end

    def self.create_readers_from_paths(paths:, fallback: "auto", compare_fields: :none)
      # default to stdin if there are no paths
      if paths.empty?
        paths << "-"
      end

      paths.map do |path|
        create_reader_from_path(path: path, fallback: fallback, compare_fields: compare_fields)
      end
    end

    def initialize(source:, compare_fields: :none)
      @source = source
      @compare_fields = resolve_compare_fields(compare_fields)
    end

    def format_name
      self.class.format_name
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
