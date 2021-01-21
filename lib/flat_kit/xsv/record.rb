require 'csv'
require 'flat_kit/record'

module FlatKit
  module Xsv
    class Record < ::FlatKit::Record

      def self.from_record(record)
        if record.instance_of?(FlatKit::Xsv::Record) then
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

        if data.nil? && (complete_structured_data.nil? || complete_structured_data.empty?) then
          raise FlatKit::Error,
            "#{self.class} requires initialization from data: or complete_structured_data:"
        end
      end

      def [](key)
        return nil unless @compare_fields.include?(key)
        if data.nil? && !@complete_structured_data.nil? then
          @complete_structured_data[key]
        else
          data[key]
        end
      end

      def complete_structured_data
        @complete_structured_data ||= data.to_hash
      end
      alias to_hash complete_structured_data

      # convert to a csv line,
      #
      # First we use data if it is there since that should be a CSV::Row
      #
      # Next, if that doesn't work - iterate over the ordered fields and use the
      # yield the values from complete_structured_data in that order
      #
      # And finally, if that doesn'twork, then just use complete structured data
      # values in that order.
      def to_s
        return data.to_csv unless data.nil?

        values = Array.new.tap do |a|
          if @ordered_fields then
            @ordered_fields.each do |field|
              a << @complete_structured_data[field]
            end
          else
            a.concat @complete_structured_data.values
          end
        end
        CSV.generate_line(values)
      end
    end
  end
end
