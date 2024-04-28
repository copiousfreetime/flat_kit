# frozen_string_literal: true

module FlatKit
  # Internal: The base class for all field types
  #
  class FieldType
    extend FlatKit::DescendantTracker

    CoerceFailure = Class.new(::Object).freeze

    def self.weights
      @weights ||= {
        # Boolean has crossover with Integer so going to let it overrule Integer
        BooleanType => 5,

        # Integer could potentially overlap with Float, but it is more restrictive
        # so let it override Flaot
        IntegerType => 4,
        FloatType => 3,

        # Date and Timestamps string representation shouldn't intersect with anything so
        # leaving it at the same level as Null and Unkonwn
        DateType => 2,
        TimestampType => 2,

        # Null and Unknown shoulnd't conflict since their string representations
        # do not intersect
        NullType => 2,
        UnknownType => 2,

        # Stringtype is the fallback for anything that has a string
        # representation, so it should lose out on integers, floats, nulls,
        # unknowns as strings
        StringType => 1,

        # at the bottom - since it should never match anywhere
        GuessType => 0,
      }
    end

    def self.candidate_types(data)
      find_children(:matches?, data)
    end

    # rubocop:disable Style/RedundantSort
    # We need the stable sort, max_by(&:weight) returns the wrong one
    def self.best_guess(data)
      candidate_types(data).sort_by(&:weight).last
    end
    # rubocop:enable Style/RedundantSort

    def self.type_name
      raise NotImplementedError, "must impleent #{type_name}"
    end

    def self.matches?(data)
      raise NotImplementedError, "must implement #{name}.matches?(data)"
    end

    def self.coerce(data)
      raise NotImplementedError, "must implement #{name}.coerce(data)"
    end

    # Each type has a weight so if a value matches multiple types, then the list
    # can be compared to see where the tie breakers are
    #
    # All the weights are here so that we can see the order of precedence
    #
    def self.weight
      weights.fetch(self) { raise NotImplementedError, "No weight assigned to type #{self} - fix immediately" }
    end
  end
end

require "flat_kit/field_type/guess_type"
require "flat_kit/field_type/boolean_type"
require "flat_kit/field_type/date_type"
require "flat_kit/field_type/timestamp_type"
require "flat_kit/field_type/integer_type"
require "flat_kit/field_type/float_type"
require "flat_kit/field_type/null_type"
require "flat_kit/field_type/string_type"
require "flat_kit/field_type/unknown_type"
