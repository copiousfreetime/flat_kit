# frozen_string_literal: true

require "test_helper"

class TestMergeTree < ::Minitest::Test
  def setup
    @dataset_count = 20
    @records_per_dataset = 100
    @records = []
    @datasets = [].tap do |a|
      @dataset_count.times do
        dd = DeviceDataset.new(count: @records_per_dataset)
        dd.persist_sorted_records_as_jsonl
        @records.concat(dd.records)
        a << dd
      end
    end
    @compare_fields = @datasets.first.compare_fields
    @readers = @datasets.map { |dd|
      ::FlatKit::Jsonl::Reader.new(source: dd.filename_sorted_jsonl, compare_fields: @compare_fields)
    }
  end

  def teardown
    @datasets.each do |ds|
      ds.cleanup_files
    end
  end

  def test_init_tree
    tree = ::FlatKit::MergeTree.new(@readers)

    assert_equal(20, tree.leaves.size)

    assert_equal(5, tree.depth)

    # 0th level should have 10 nodes - since 20 leaves
    assert_equal(10, tree.levels[0].size)

    # 1st level should have 5 nodes - since 10 nodes lower
    assert_equal(5, tree.levels[1].size)

    # 2nd level should have 3 nodes - since 5 above (and we shim in a Sentinel
    # node on the last internal node)
    assert_equal(3, tree.levels[2].size)
    assert_instance_of(::FlatKit::SentinelInternalNode, tree.levels[2].last.right)

    # 3rd level should have 2 nodes
    assert_equal(2, tree.levels[3].size)

    # 4th level should have 1 nodes
    assert_equal(1, tree.levels[4].size)
  end

  def test_merging
    expected_records = @records.sort_by { |r| @compare_fields.map { |f| r[f] } }
    tree = ::FlatKit::MergeTree.new(@readers)
    actual_records = tree.to_a.map { |r| r.to_hash }

    assert_equal(expected_records.size, actual_records.size)

    expected_records.each_with_index do |expected, idx|
      actual = actual_records[idx]

      assert_equal(expected, actual)
    end
  end
end
