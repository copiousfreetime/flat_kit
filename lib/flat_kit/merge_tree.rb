# frozen_string_literal: true

module FlatKit
  # Public: Merge a list of sorted records from Readers into a single output Writer
  #
  # The MergeTree implements a Tournament Tree algorightm to do a k-way merge
  # between Reader objects:
  #
  #   https://en.wikipedia.org/wiki/K-way_merge_algorithm
  #
  # Usage:
  #
  #   compare_fields = %w[ key timestamp ]
  #   format = ::FlatKit::Format.for('json')
  #
  #   readers = ARGV.map do |path|
  #     format.reader.new(source: path, compare_fields: compare_fields)
  #   end
  #
  #   write_path = "merged.jsonl"
  #   writer = format.writer.new(destination: write_path.to_s)
  #
  #   tree = ::FlatKit::MergeTree.new(readers)
  #
  #   tree.each do |record|
  #      writer.write(record)
  #   end
  #   writer.close
  #
  #
  class MergeTree
    include Enumerable

    attr_reader :leaves, :levels, :readers

    def initialize(readers)
      @readers = readers
      @leaves = []
      @levels = []

      @readers.each do |reader|
        @leaves << LeafNode.new(reader)
      end

      # Need to pad the leaves to an even number so that the slicing by 2 for
      # the tournament will work
      if @leaves.size.odd?
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

        # we alays need a left and a right node, there is the possibility of
        # adding a single Sentinel node as the final right node in each level
        values.each_slice(2) do |left, right|
          right = SentinelInternalNode.new if right.nil?
          winners << InternalNode.new(left: left, right: right)
        end
        values = winners
        @levels << winners
      end
    end

    #
    # Root is the last level - should only have one node
    #
    def root
      @levels[-1].first
    end

    #
    # The number of levels, this shold be the logn(readers.size)
    #
    def depth
      @levels.size
    end

    #
    # Iterate over all the ements from all the readers yielding them in sorted
    # order.
    #
    def each
      loop do
        break if root.leaf.finished?

        yield root.value
        # consume the yielded value and have the tournament tree replay those
        # brackets affected
        root.leaf.update_and_replay
      end
    end
  end
end
