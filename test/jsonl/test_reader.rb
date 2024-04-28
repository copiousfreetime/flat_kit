# frozen_string_literal: true

require_relative "../test_helper"

module TestJsonl
  class TestReader < ::Minitest::Test
    def setup
      @count = 20
      @dataset = DeviceDataset.new(count: @count)
      @compare_fields = @dataset.compare_fields
      @test_path = "tmp/test_reads_from_io.jsonl"

      File.open(@test_path, "wb") do |f|
        f.write(@dataset.records_as_jsonl)
      end
    end

    def teardown
      FileUtils.rm_f(@test_path)
    end

    def test_raises_error_on_invalid_source
      assert_raises(::FlatKit::Error) {
        ::FlatKit::Jsonl::Reader.new(source: Object.new, compare_fields: nil)
      }
    end

    def test_reads_from_pathname
      reader = ::FlatKit::Jsonl::Reader.new(source: @test_path, compare_fields: @compare_fields)
      all = reader.to_a

      assert_equal(@count, reader.count)
      assert_equal(@count, all.size)
    end

    def test_reads_from_io
      File.open(@test_path) do |f|
        reader = ::FlatKit::Jsonl::Reader.new(source: f, compare_fields: @compare_fields)
        all = reader.to_a

        assert_equal(@count, reader.count)
        assert_equal(@count, all.size)
      end
    end

    def test_raises_error_on_io_error
      s = StringIO.new
      s.close_read
      reader = ::FlatKit::Jsonl::Reader.new(source: s, compare_fields: @compare_fields)
      assert_raises(::FlatKit::Error) { reader.to_a }
    end
  end
end
