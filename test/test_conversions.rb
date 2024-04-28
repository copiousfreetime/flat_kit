# frozen_string_literal: true

require "test_helper"

class TestConversions < ::Minitest::Test
  def setup
    @one_row_dataset = DeviceDataset.new(count: 1)
    @src_record = @one_row_dataset.records.first
    @csv_row = @one_row_dataset.records_as_csv_rows.first
    @compare_fields = @one_row_dataset.compare_fields
  end

  def test_from_csv_to_json
    xsv_record = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
    json_record = FlatKit::Jsonl::Record.from_record(xsv_record)

    assert_equal(@one_row_dataset.records.first, xsv_record.to_hash)
    assert_equal(@one_row_dataset.records.first, json_record.to_hash)
    assert_equal(xsv_record, json_record)
  end

  def test_from_json_to_csv
    src_json = JSON.generate(@src_record)
    json_record = FlatKit::Jsonl::Record.new(data: src_json, compare_fields: @compare_fields)
    xsv_record = FlatKit::Xsv::Record.from_record(json_record)

    assert_equal(@one_row_dataset.records.first, xsv_record.to_hash)
    assert_equal(@one_row_dataset.records.first, json_record.to_hash)
    assert_equal(xsv_record, json_record)
  end

  def test_roundtrip_csv_json_csv
    xsv_record = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
    json_record = FlatKit::Jsonl::Record.from_record(xsv_record)
    xsv2 = FlatKit::Xsv::Record.from_record(json_record)

    assert_equal(xsv_record.to_s, xsv2.to_s)
  end

  def test_roundtrip_json_csv_json
    src_json = JSON.generate(@src_record)
    json_record = FlatKit::Jsonl::Record.new(data: src_json, compare_fields: @compare_fields)
    xsv_record = FlatKit::Xsv::Record.from_record(json_record)
    json2 = FlatKit::Jsonl::Record.from_record(xsv_record)
    assert_equal(src_json, json2.to_s)
  end
end
