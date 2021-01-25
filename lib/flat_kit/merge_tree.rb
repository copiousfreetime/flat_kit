module FlatKit
  class MergeTree
    attr_reader :leaves
    attr_reader :levels
    attr_reader :root

    def initialize(readers)
      @readers = readers
      @root = nil

      @leaves = []
      @levels = []

      @readers.each do |reader|
        @leaves << LeafNode.new(reader)
      end

      if @leaves.size.odd? then
        @leaves << SentinelLeafNode.new
      end

      init_tree
    end

    #
    # Initialize the tournament tree, go in depths - bottom layer will be the
    # losers of the 2 leaf nodes, next layer will be 
    def init_tree
      values = @leaves.dup
      loop do
        break if values.size == 1

        # need to make sure we have an even number of elements in values
        if values.size.odd? then
          values << SentinelInternalNode.new
        end

        losers = []

        values.each_slice(2) do |left, right|
          losers << InternalNode.new(left: left, right: right)
        end
        values = losers
        @levels << losers
      end
    end

    def root
      @levels[-1].first
    end

    def depth
      @levels.size
    end
  end
end
