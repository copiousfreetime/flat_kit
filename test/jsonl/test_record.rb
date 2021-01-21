require_relative '../test_helper'
require 'faker'
require 'byebug'

module TestJsonl
  class TestRecord < ::Minitest::Test
    def setup
      @one_row_dataset = DeviceDataset.new(count: 1)
      @src_record = @one_row_dataset.records.first
      @src_json = JSON.generate(@src_record)
      @compare_fields = @one_row_dataset.compare_fields
    end

    def test_initializes_from_data
      record = FlatKit::Jsonl::Record.new(data: @src_json, compare_fields: @compare_fields)
      @compare_fields.each do |k|
        assert_equal(@src_record[k], record[k])
      end
    end

    def test_ignores_non_compare_fields_values
      record     = FlatKit::Jsonl::Record.new(data: @src_json, compare_fields: @compare_fields)

      refute(record["version"])
    end

    def test_is_sortable
      dataset = DeviceDataset.new(count: 20)
      fk_records = Array.new.tap do |a|
        dataset.records.each do |r|
          data = JSON.generate(r)
          record = FlatKit::Jsonl::Record.new(data: data, compare_fields: @compare_fields)
          a << record
        end
      end

      sorted = fk_records.sort

      sio = StringIO.new
      sorted.each do |r|
        sio.puts(r.to_s)
      end

      sorted_string = sio.string
      assert_equal(dataset.sorted_records_as_jsonl, sorted_string)
    end

    def test_converts_to_hash
      record = FlatKit::Jsonl::Record.new(data: @src_json, compare_fields: @compare_fields)
      h      = record.to_hash

      assert_equal(@src_record, h)
    end

    def test_converts_from_record
      rec1 = FlatKit::Jsonl::Record.new(data: @src_json, compare_fields: @compare_fields)
      rec2 = FlatKit::Jsonl::Record.from_record(rec1)
      assert_equal(rec1, rec2)
    end
  end
end
