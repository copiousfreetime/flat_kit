module FlatKit
  class SentinelLeafNode
    include Comparable

    def sentinel?
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
