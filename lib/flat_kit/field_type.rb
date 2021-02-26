module FlatKit
  class FieldType

    extend FlatKit::DescendantTracker

    def self.candidate_types(data)
      find_children(:matches?, data)
    end

    def self.best_guess(data)
      candidate_types(data).sort_by { |t| t.weight }.last
    end

    def self.matches?(data)
      raise NotImplementedError, "must implement #{self.name}.matches?(data)"
    end

    # Each type has a weight so if a value matches multiple types, then the list
    # can be compared to see where the tie breakers are
    #
    # All the weights are here so that 
    #
    #
    def self.weight
      # Boolean has crossover with Integer so going to let it overrule Integer
      return 5 if self == BooleanType


      # Integer could potentially overlap with Float, but it is more restrictive
      # so let it override Flaot
      return 4 if self == IntegerType
      return 3 if self == FloatType

      # DateTime's string representation shouldn't intersect with anything so
      # leaving it at the same level as Null and Unkonwn
      return 2 if self == DateTimeType

      # Null and Unknown shoulnd't conflict since their string representations
      # do not intersect
      return 2 if self == NullType
      return 2 if self == UnknownType

      # Stringtype is the fallback for anything that has a string
      # representation, so it should lose out on integers, floats, nulls,
      # unknowns as strings
      return 1 if self == StringType

      # at the bottom - since it should never match anywhere
      return 0 if self == GuessType

      raise NotImplementedError, "No weight assigned to type #{self} - fix immediately"
    end
  end
end

require 'flat_kit/field_type/guess_type'
require 'flat_kit/field_type/boolean_type'
require 'flat_kit/field_type/date_time_type'
require 'flat_kit/field_type/integer_type'
require 'flat_kit/field_type/float_type'
require 'flat_kit/field_type/null_type'
require 'flat_kit/field_type/string_type'
require 'flat_kit/field_type/unknown_type'