module FlatKit
  class FieldType

    extend FlatKit::DescendantTracker

    def self.candidate_types(data)
      find_children(:matches?, data)
    end

  end
end

require 'flat_kit/field_type/boolean_type'
require 'flat_kit/field_type/integer_type'
require 'flat_kit/field_type/float_type'
