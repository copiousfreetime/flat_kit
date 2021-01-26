module FlatKit
  # Private: This is a class used internally by MergeTree and should not be used
  # outside of that context.
  #
  # The InternalNode represents a single element of the tournament tree
  # altorithm holding references to the to other internal nodes that competed in
  # this node and which one is the winner.
  #
  # A reference to the leaf node that is associated with the winner is also kept
  # here.
  #
  class InternalNode

    include Comparable

    attr_accessor :left        # Internal Node
    attr_accessor :right       # Internal Node
    attr_accessor :winner      # Internal Node
    attr_accessor :next_level  # Who to tell
    attr_accessor :leaf        # winning leaf node

    def initialize(left:, right:)
      @left       = left
      @left.next_level = self

      @right      = right
      @right.next_level = self
      @next_level  = nil

      play
    end

    def value
      winner.value
    end

    def sentinel?
      false
    end

    def leaf?
      false
    end

    # We are being told that the passed in node no longer has data in it and is
    # to be removed from the tree.
    #
    # We replace our reference to this node with a sentinal node so that
    # comparisons work correctly.
    #
    # After updating the node, we then need to check and see if both of our
    # child nodes are sentinels, and if so, then tell our parent to remove us
    # from the tree.
    #
    def player_finished(node)
      if left.object_id == node.object_id then
        @left = SentinelInternalNode.new
        @left.next_level = self
      elsif right.object_id == node.object_id then
        @right = SentinelInternalNode.new
        @right.next_level = self
      else
        raise FlatKit::Error, "Unknown player #{node}"
      end

      if @right.sentinel? && @left.sentinel? then
        next_level.player_finished(self) if next_level
      end
    end

    def play
      @winner = left <= right ? left : right
      if !@winner.sentinel? then
        @leaf = winner.leaf
      end
      next_level.play if next_level
    end

    def <=>(other)
      return -1 if other.sentinel?
      value.<=>(other.value)
    end
  end
end
