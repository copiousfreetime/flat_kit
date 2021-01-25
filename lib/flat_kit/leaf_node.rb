module FlatKit
  class LeafNode

    include Comparable

    attr_reader :reader
    attr_reader :value

    def initialize(reader)
      @reader = reader
      @enum = @reader.to_enum
      @value = @enum.next
    end

    def sentinel?
      false
    end

    def external_node
      self
    end

    def next
      begin
        @value = @enum.next
      rescue StopIteration
        @value = nil
      end
      @value
    end

    def finished?
      @enum && @value.nil?
    end

    def <=>(other)
      return -1 if other.sentinel?
      self.value.<=>(other.value)
    end
  end
end
