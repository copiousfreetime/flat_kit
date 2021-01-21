require 'test_helper'
require 'faker'
require 'byebug'

class TestJSONRecord< ::Minitest::Test
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
    record     = FlatKit::JSONRecord.new(data: data, sort_key: @key)
    @key.each do |k|
      assert_equal(src_record[k], record[k])
    end
  end

  def test_ignores_non_sort_key_values
    src_record = @records.first
    data       = JSON.generate(src_record)
    record     = FlatKit::JSONRecord.new(data: data, sort_key: @key)

    refute(record["version"])
  end

  def test_is_sortable
    fk_records = Array.new.tap do |a|
      @records.each do |r|
        data = JSON.generate(r)
        record = FlatKit::JSONRecord.new(data: data, sort_key: @key)
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
end
