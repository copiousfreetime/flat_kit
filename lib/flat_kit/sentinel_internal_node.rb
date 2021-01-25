module FlatKit
  class SentinelInternalNode
    include Comparable

    attr_reader :left
    attr_reader :right
    attr_reader :winner
    attr_accessor :next_level

    def initialize(left: nil, right: nil)
      @left = nil
      @right = nil
      @winner = nil
      @next_level = nil
    end

    def sentinel?
      true
    end

    def leaf?
      true
    end

    # A sentinal node is always greater than any other node
    def <=>(other)
      return 0 if other.sentinel?
      return 1
    end
  end
end
