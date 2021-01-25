module FlatKit
  class InternalNode

    include Comparable

    attr_accessor :value
    attr_accessor :left
    attr_accessor :right

    def initialize(left:, right:)
      @left     = left
      @right    = right
      @value    = left <= right ? left.value : right.value
    end

    def sentinel?
      false
    end

    def <=>(other)
      return -1 if other.sentinel?
      @value.<=>(other.value)
    end
  end
end
