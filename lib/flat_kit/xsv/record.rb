require 'csv'
require 'flat_kit/record'

module FlatKit
  module Xsv
    class Record < ::FlatKit::Record
      def initialize(data:, compare_fields:)
        super(data: data, compare_fields: compare_fields)
      end

      def [](key)
        return nil unless @compare_fields.include?(key)
        data[key]
      end

      def to_s
        @data.to_csv
      end
    end
  end
end
