module FlatKit
  class Input
    extend DescendantTracker

    def self.from(input)
      return input if input.kind_of?(::FlatKit::Input)

      in_klass = find_child(:handles?, input)
      if in_klass then
        return in_klass.new(input)
      end

      raise FlatKit::Error, "Unable to create input from #{input.class} : #{input.inspect}"
    end

    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    #
    def read
      raise NotImplementedError, "#{self.class} must implement #read"
    end

    def close
      raise NotImplementedError, "#{self.class} must implement #close"
    end
  end
end

require 'flat_kit/input/io'
