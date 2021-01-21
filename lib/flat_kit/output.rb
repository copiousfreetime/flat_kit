module FlatKit
  class Output
    extend DescendantTracker

    def self.from(out)
      return out if out.kind_of?(::FlatKit::Output)

      out_klass = find_child(:handles?, out)
      if out_klass then
        return out_klass.new(out)
      end

      raise FlatKit::Error, "Unable to create output from #{out.class} : #{out.inspect}"
    end

    def name
      raise NotImplementedError, "#{self.class} must implement #name"
    end

    #
    def io
      raise NotImplementedError, "#{self.class} must implement #io"
    end

    def close
      raise NotImplementedError, "#{self.class} must implement #close"
    end
  end
end

require 'flat_kit/output/io'
require 'flat_kit/output/file'
