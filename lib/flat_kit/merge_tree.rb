module FlatKit
  class MergeTree
    attr_reader :leaves
    attr_reader :levels
    attr_reader :readers

    def initialize(readers)
      @readers = readers
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
    # winners of the 2 leaf nodes, continuing until top layer is just 1 node
    #
    def init_tree
      values = @leaves.dup
      loop do
        break if values.size == 1

        winners = []

        values.each_slice(2) do |left, right|
          right = SentinelInternalNode.new if right.nil?
          winners << InternalNode.new(left: left, right: right)
        end
        values = winners
        @levels << winners
      end
    end

    def root
      @levels[-1].first
    end

    def depth
      @levels.size
    end

    def each
      loop do
        break if root.leaf.finished?
        yield root.value
        leaf = root.leaf
        leaf.update_and_replay
      end
    end

    def walk
      traverse(root)
    end

    def traverse(node)
      traverse(node.left) unless node.leaf?
      $stderr.puts "#{node.class}"
      traverse(node.right) unless node.leaf?
    end
  end
end
