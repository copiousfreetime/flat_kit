module FlatKit
  # Private: The Sentinel Internal Node is a private class used by the MergeTree
  # class.
  #
  # This class represents an empty / completed node in the merge tree where all
  # the data from the descendant leaf node is full used up.
  #
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
