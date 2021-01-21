require 'csv'
require 'flat_kit/record'

module FlatKit
  module Xsv
    class Record < ::FlatKit::Record
      def self.from_record(record)
        if record.instance_of(FlatKit::Xsv::Record) then
          new(data: record.data, compare_fields: record.compare_fields)
        else
          new(data: nil, compare_fields: record.compare_fields,
              ordered_fields: nil,
              complete_structured_data: record.to_hash)
        end
      end

      def initialize(data:, compare_fields:,
                     ordered_fields: nil,
                     complete_structured_data: nil)
        super(data: data, compare_fields: compare_fields)
        @ordered_fields = ordered_fields
        @complete_structured_data = complete_structured_data

        if data.nil? && (complete_strucutred_data.nil? || complete_structured_data.empty?) then
          raise FlatKit::Error,
            "#{self.class} requires initialization from data: or complete_strucuted_data:"
        end
      end

      def [](key)
        return nil unless @compare_fields.include?(key)
        data[key]
      end

      def complete_structured_data
        @complete_structured_data ||= data.to_hash
      end
      alias to_hash complete_structured_data

      def to_s
        @data.to_csv
      end
    end
  end
end
