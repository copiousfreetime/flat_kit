module FlatKit
  class MergeNode

    include Comparable

    attr_reader :reader
    attr_reader :current

    def initialize(reader)
      @reader = reader
      @enum = @reader.to_enum
      @current = @enum.next
    end

    def next
      begin
        @current = @enum.next
      rescue StopIteration
        @current = nil
      end
      @current
    end

    def finished?
      @enum && @current.nil?
    end

    def <=>(other)
      self.current.<=>(other.current)
    end
  end
end
