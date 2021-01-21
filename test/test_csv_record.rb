require 'test_helper'
require 'faker'
require 'byebug'

class TestCSVRecord< ::Minitest::Test
  def setup
    @records              = Array.new.tap do |a|
      20.times do
        a << {
          "build_number" => Faker::Device.build_number,
          "manufacturer" => Faker::Device.manufacturer,
          "model_name"   => Faker::Device.model_name,
          "platform"     => Faker::Device.platform,
          "serial"       => Faker::Device.serial,
          "version"      => Faker::Device.version
        }
      end
    end

    @ordered_keys  = %w[ build_number manufacturer model_name platform version serial ]
    @key           = %w[ manufacturer model_name ]
    @sorted_records = @records.sort_by { |r| [r["manufacturer"], r["model_name"]] }

    @unsorted_data = @records.map { |r| @ordered_keys.map { |k| r[k] } }
    @sorted_data   = @sorted_records.map { |r| @ordered_keys.map { |k| r[k] } }

    @sorted_text = CSV.generate('', headers: @ordered_keys, write_headers: true) do |csv|
      @sorted_data.each do |row|
        csv << row
      end
    end

    @csv_rows = []

    CSV.new(@sorted_text, headers: :first_row, return_headers: false).each do |row|
      @csv_rows << row
    end
  end

  def test_initializes_from_data
    data   = @csv_rows.first
    record = FlatKit::CSVRecord.new(data: data, sort_key: @key)
    @key.each do |k|
      assert_equal(data[k], record[k])
    end
  end

  def test_ignores_non_sort_key_values
    data   = @csv_rows.first
    record = FlatKit::CSVRecord.new(data: data, sort_key: @key)

    refute(record["version"])
  end

   def test_is_sortable
     fk_records = Array.new.tap do |a|
       @csv_rows.each do |data|
         a << FlatKit::CSVRecord.new(data: data, sort_key: @key)
       end
     end

     sorted = fk_records.sort
     output_text = CSV.generate('', headers: @ordered_keys, write_headers: true) do |csv|
       sorted.each do |row|
         csv << row.data
       end
     end

     assert_equal(output_text, @sorted_text)
   end
end
