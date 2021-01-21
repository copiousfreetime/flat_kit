require 'oj'
require 'forwardable'

module FlatKit
  class JSONRecord

    include Comparable

    attr_reader :data
    attr_reader :sort_key
    attr_reader :sort_data

    extend Forwardable

    def initialize(data:, sort_key:)
      @data = data
      @sort_key = sort_key
      @sort_data = Hash.new
      setup
    end

    def [](key)
      sort_data[key]
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
      @data
    end

    def setup
      Oj::Doc.open(data) do |doc|
        sort_key.each do |key_part|
          val = doc.fetch("/#{key_part}")
          @sort_data[key_part] = val
        end
      end
    end
  end
end
