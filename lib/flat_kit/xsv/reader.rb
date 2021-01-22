require 'csv'

module FlatKit
  module Xsv
    class Reader < ::FlatKit::Reader
      attr_reader :input
      attr_reader :count
      attr_reader :fields

      def self.default_csv_options
        {
          headers: :first_row,
          converters: :numeric,
          return_headers: false
        }
      end

      def initialize(source:, compare_fields: :none, **csv_options)
        super(source: source, compare_fields: compare_fields)
        @input = ::FlatKit::Input.from(source)
        @count = 0
        @csv_options = Reader.default_csv_options.merge(csv_options)
        @fields = nil
        @csv = CSV.new(input.io, **@csv_options)
      end

      def each
        @csv.each do |row|
          @fields = row.headers if @fields.nil?
          record = ::FlatKit::Xsv::Record.new(data: row, compare_fields: compare_fields)
          @count += 1
          yield record
        end
        input.close
      rescue => e
        ::FlatKit.logger.error "Error reading xsv records from #{input.name}: #{e}"
        raise ::FlatKit::Error, e
      end
    end
  end
end
