module FlatKit
  class FieldType

    extend FlatKit::DescendantTracker

    def self.candidate_types(data)
      find_children(:matches?, data)
    end

  end
end

require 'flat_kit/field_type/integer_type'
