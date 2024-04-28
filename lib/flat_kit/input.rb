# frozen_string_literal: true

module FlatKit
  class Input
    extend DescendantTracker

    def self.from(input)
      return input if input.is_a?(::FlatKit::Input)

      in_klass = find_child(:handles?, input)
      return in_klass.new(input) if in_klass

      raise FlatKit::Error, "Unable to create input from #{input.class} : #{input.inspect}"
    end

    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    def io
      raise NotImplementedError, "#{self.class} must implement #io"
    end

    def close
      raise NotImplementedError, "#{self.class} must implement #close"
    end
  end
end

require "flat_kit/input/io"
require "flat_kit/input/file"
