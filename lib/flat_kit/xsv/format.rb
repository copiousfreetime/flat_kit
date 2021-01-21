module FlatKit
  module Xsv
    class Format < ::FlatKit::Format
      def self.handles?(filename)
        parts = filename.split(".")
        %w[ csv tsv txt ].each do |ext|
          return true if parts.include?(ext)
        end
        return false
      end
    end
  end
end
