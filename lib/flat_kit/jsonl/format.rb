module FlatKit
  module Jsonl
    class Format < ::FlatKit::Format
      def self.handles?(filename)
        parts = filename.split(".")
        %w[ json jsonl ndjson ].each do |ext|
          return true if parts.include?(ext)
        end
        return false
      end
    end
  end
end
