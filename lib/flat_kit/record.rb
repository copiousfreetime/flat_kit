module FlatKit
  class Record

    include Comparable

    attr_reader :data
    attr_reader :compare_fields

    def initialize(data:, compare_fields:)
      @data = data
      @compare_fields = compare_fields
    end

    def <=>(other)
      compare_result = nil

      compare_fields.each do |field|
        my_val         = self[field]
        other_val      = other[field]
        compare_result = my_val.<=>(other_val)

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
