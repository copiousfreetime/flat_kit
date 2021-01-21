require_relative '../test_helper'
require 'faker'
require 'byebug'

module TestJsonl
  class TestRecord < ::Minitest::Test
    def setup
      @records = Array.new.tap do |a|
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
      @key    = [ "manufacturer", "model_name" ]
      @sorted = @records.sort_by { |r| [r["manufacturer"], r["model_name"]] }

      sio = StringIO.new
      @sorted.each do |r|
        sio.puts(JSON.generate(r))
      end
      @sorted_text = sio.string
    end

    def test_initializes_from_data
      src_record = @records.first
      data       = JSON.generate(src_record)
      record     = FlatKit::Jsonl::Record.new(data: data, compare_fields: @key)
      @key.each do |k|
        assert_equal(src_record[k], record[k])
      end
    end

    def test_ignores_non_compare_fields_values
      src_record = @records.first
      data       = JSON.generate(src_record)
      record     = FlatKit::Jsonl::Record.new(data: data, compare_fields: @key)

      refute(record["version"])
    end

    def test_is_sortable
      fk_records = Array.new.tap do |a|
        @records.each do |r|
          data = JSON.generate(r)
          record = FlatKit::Jsonl::Record.new(data: data, compare_fields: @key)
          a << record
        end
      end

      sorted = fk_records.sort
      sio = StringIO.new
      sorted.each do |r|
        sio.puts(r.to_s)
      end
      sorted_string = sio.string
      assert_equal(sorted_string, @sorted_text)
    end

    def test_converts_to_hash
      src_record = @records.first
      data       = JSON.generate(src_record)
      record     = FlatKit::Jsonl::Record.new(data: data, compare_fields: @key)
      h          = record.to_hash

      assert_equal(src_record, h)
    end

    def test_converts_from_record
      data = JSON.generate(@records.first)
      rec1 = FlatKit::Jsonl::Record.new(data: data, compare_fields: @key)
      rec2 = FlatKit::Jsonl::Record.from_record(rec1)
      assert_equal(rec1, rec2)
    end
  end
end
