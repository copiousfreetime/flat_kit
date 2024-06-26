# frozen_string_literal: true

module FlatKit
  # Internal: Base clases for all output handlers
  #
  class Output
    extend DescendantTracker

    def self.from(out)
      return out if out.is_a?(::FlatKit::Output)

      out_klass = find_child(:handles?, out)
      return out_klass.new(out) if out_klass

      raise FlatKit::Error, "Unable to create output from #{out.class} : #{out.inspect}"
    end

    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    def io
      raise NotImplementedError, "#{self.class} must implement #io"
    end

    def tell
      io.tell
    end

    def close
      raise NotImplementedError, "#{self.class} must implement #close"
    end
  end
end

require "flat_kit/output/io"
require "flat_kit/output/file"
