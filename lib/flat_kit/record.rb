# frozen_string_literal: true

module FlatKit
  # Public: The base class that all record classes should inherit from.
  #
  # Its goal is to be an efficient comparator of data that can be inflated from
  # a source structure to a fully realized hash.
  #
  # All records need to be able to be initialized from a data structure that it
  # is handed to it by the Reader intance within the same Format.
  #
  # Records are generally not going to be created outside of this library, they
  # are tied to a specific format and provide a common interface that can be
  # used for:
  #
  #   * comparison between records from different source / destinations formats
  #   * conversion to a different format
  #
  # Given that - the way to create a record is either from another Record
  # instance:
  #
  #   Record.from_record(other)  # create a record from another record
  #
  # or the way a Reader will do it
  #
  #   Record.new(...)            # generally only used by a Reader instance to
  #                              # yield new reocrds
  #
  #
  # When Implementing a new Format, the corresponding Record class for that
  # Format must:
  #
  #   * implement `#[](key)` which will be used to lookup the values of the
  #     comparable fields.
  #   * implement `#to_hash` which is used when conversions
  #   * implement `.from_record` which is used in conversion
  #   # the initialize method must call super(data:, compare_fields:) to
  #     initializa the root data structures
  class Record
    include Comparable

    attr_reader :data, :compare_fields

    def initialize(data:, compare_fields:)
      @data = data
      @compare_fields = compare_fields
    end

    def format_name
      self.class.format_name
    end

    def <=>(other)
      compare_result = nil

      compare_fields.each do |field|
        my_val         = self[field]
        other_val      = other[field]

        if my_val.nil? && other_val.nil? then
          compare_result = 0
        elsif my_val.nil?
          compare_result = -1
        elsif other_val.nil?
          compare_result = 1
        else
          compare_result = my_val.<=>(other_val)
        end

        return compare_result unless compare_result.zero?
      end
      compare_result
    end

    def [](key)
      raise NotImplementedError, "#{self.class} must implement #[](key)"
    end

    def to_hash
      raise NotImplementedError, "#{self.class} must implement #to_hash"
    end

    def self.from_record
      raise NotImplementedError, "#{self.class} must implement #{self.class}.from_record"
    end
  end
end
