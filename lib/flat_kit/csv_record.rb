require 'csv'

module FlatKit
  class CSVRecord

    include Comparable

    attr_reader :data
    attr_reader :sort_key

    def initialize(data:, sort_key:)
      @data = data         # CSV::Row or Array
      @sort_key = sort_key # assumed to be keys into the data, or offsets
    end

    def [](key)
      return nil unless @sort_key.include?(key)
      data[key]
    end

    def <=>(other)
      compare_result = nil

      sort_key.each do |key_part|
        my_val         = self[key_part]
        other_val      = other[key_part]
        compare_result = my_val.<=>(other_val)

        return compare_result unless compare_result.zero?
      end
      compare_result
    end

    def to_s
      @data.to_csv
    end
  end
end
