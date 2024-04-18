require 'test_helper'
require 'faker'

module TestXsv
  class TestRecord< ::Minitest::Test
    def setup
      @one_row_dataset = DeviceDataset.new(count: 1)
      @csv_row = @one_row_dataset.records_as_csv_rows.first
      @compare_fields = @one_row_dataset.compare_fields
    end

    def test_initializes_from_data
      record = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
      original_record = @one_row_dataset.records.first
      @compare_fields.each do |field|
        assert_equal(original_record[field], record[field])
      end
    end

    def test_ignores_non_compare_fields_values
      record = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
      refute(record["version"])
    end

    def test_is_sortable
      dataset = DeviceDataset.new(count: 20)
      fk_records = Array.new.tap do |a|
        dataset.records_as_csv_rows.each do |csv_row|
          a << FlatKit::Xsv::Record.new(data: csv_row, compare_fields: @compare_fields)
        end
      end

      sorted = fk_records.sort
      output_text = CSV.generate('', headers: dataset.fields, write_headers: true) do |csv|
        sorted.each do |row|
          csv << row.data
        end
      end

      assert_equal(output_text, dataset.sorted_records_as_csv)
    end

    def test_to_hash
      record = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
      h = record.to_hash
      assert_equal(@one_row_dataset.records.first, h)
    end

    def test_from_record
      rec1 = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
      rec2 = FlatKit::Xsv::Record.from_record(rec1)
      assert_equal(rec1, rec2)
    end

    def test_incomplete_initialization
      assert_raises(FlatKit::Error) {
        FlatKit::Xsv::Record.new(data: nil, compare_fields: [])
      }
    end

    def test_to_s_from_csv_record
      record = FlatKit::Xsv::Record.new(data: @csv_row, compare_fields: @compare_fields)
      line = record.to_s
      expected = @one_row_dataset.records_as_csv_rows[0].to_csv
      assert_equal(expected, line)
    end
  end
end
