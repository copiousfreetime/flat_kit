require 'oj'
require 'flat_kit/record'

module FlatKit
  module Jsonl
    class Record < ::FlatKit::Record
      attr_reader :compare_data

      def self.from_record(record)
        if record.instance_of?(FlatKit::Jsonl::Record) then

          structured = record.complete_structured_data? ? record.complete_structured_data : nil

          new(data: record.data, compare_fields: record.compare_fields,
              compare_data: record.compare_data,
              complete_structured_data: structured)
        else
          new(data: nil, compare_fields: record.compare_fields,
              complete_structured_data: record.to_hash)
        end
      end

      def initialize(data:, compare_fields: :none,
                     compare_data: Hash.new,
                     complete_structured_data: nil)
        super(data: data, compare_fields: compare_fields)

        @complete_structured_data = complete_structured_data

        if complete_structured_data? && (compare_data.nil? || compare_data.empty?) then
          @compare_data = complete_structured_data
        else
          @compare_data = compare_data
        end

        # only load compare data if it dosn't exist
        if data && compare_data.empty? then
          quick_parse
        end
      end

      def [](key)
        compare_data[key]
      end

      def complete_structured_data
        @complete_structured_data ||= Oj.load(data)
      end
      alias to_hash complete_structured_data

      def complete_structured_data?
        !(@complete_structured_data.nil? || @complete_structured_data.empty?)
      end

      # overriding parent accessor since we may be initialized without raw bytes
      # to parse
      def data
        if @data.nil? && complete_structured_data? then
          @data = Oj.dump(complete_structured_data)
        end
        @data
      end
      alias to_s data

      private

      def quick_parse
        Oj::Doc.open(data) do |doc|
          compare_fields.each do |field|
            val = doc.fetch("/#{field}")
            @compare_data[field] = val
          end
        end
      end
    end
  end
end



