# frozen_string_literal: true

module FlatKit
  module Xsv
    # Internal: xsv format class holding the metadata about the xsv format utilities
    #
    class Format < ::FlatKit::Format
      def self.format_name
        "xsv"
      end

      def self.handles?(filename)
        parts = filename.split(".")
        %w[csv tsv txt].each do |ext|
          return true if parts.include?(ext)
        end
        false
      end

      def self.reader
        ::FlatKit::Xsv::Reader
      end

      def self.writer
        ::FlatKit::Xsv::Writer
      end
    end
  end
end
