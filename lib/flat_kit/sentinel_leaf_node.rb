# frozen_string_literal: true

module FlatKit
  # Private: The Sentinel Leaf Node is used internally by the MergeTree
  #
  # This class represents a LeafNode that has no more data
  #
  class SentinelLeafNode
    include Comparable

    attr_accessor :next_level

    def sentinel?
      true
    end

    def leaf?
      true
    end

    def next
      nil
    end

    def finished?
      true
    end

    def value
      nil
    end

    # A sentinal node is always greater than any other node
    def <=>(other)
      return 0 if other.sentinel?

      return 1
    end
  end
end
