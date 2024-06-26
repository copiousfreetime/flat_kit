# frozen_string_literal: true

require "oj"
require "flat_kit/record"

module FlatKit
  module Jsonl
    # Internal: Class that exposes data from a JSONL format record to the flatkit api
    #
    class Record < ::FlatKit::Record
      attr_reader :compare_data

      def self.format_name
        ::FlatKit::Jsonl::Format.format_name
      end

      def self.from_record(record)
        if record.instance_of?(FlatKit::Jsonl::Record)

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
                     compare_data: {},
                     complete_structured_data: nil)
        super(data: data, compare_fields: compare_fields)

        @complete_structured_data = complete_structured_data

        @compare_data = if complete_structured_data? && (compare_data.nil? || compare_data.empty?)
                          complete_structured_data
                        else
                          compare_data
                        end

        # only load compare data if it dosn't exist
        quick_parse if data && compare_data.empty?
      end

      def [](key)
        compare_data[key]
      end

      def complete_structured_data
        @complete_structured_data ||= Oj.load(data, mode: :strict)
      end
      alias to_hash complete_structured_data

      def complete_structured_data?
        !(@complete_structured_data.nil? || @complete_structured_data.empty?)
      end

      # overriding parent accessor since we may be initialized without raw bytes
      # to parse
      def data
        @data = Oj.dump(complete_structured_data, mode: :json) if @data.nil? && complete_structured_data?
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
