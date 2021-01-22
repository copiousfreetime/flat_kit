require_relative '../test_helper'

module TestJsonl
  class TestWriter < ::Minitest::Test
    def setup
      @count = 20
      @dataset = DeviceDataset.new(count: @count)
      @compare_fields = @dataset.compare_fields
      @write_path = "tmp/test_writes_to_io.jsonl"
      @read_path = "tmp/test_read.jsonl"

      File.open(@read_path, "wb") do |f|
        f.write(@dataset.records_as_jsonl)
      end

      @reader = ::FlatKit::Jsonl::Reader.new(source: @read_path, compare_fields: @compare_fields)
      @records = @reader.to_a
    end

    def teardown
      File.unlink(@write_path) if File.exist?(@write_path)
      File.unlink(@read_path) if File.exist?(@read_path)
    end

    def test_raises_error_on_invalid_destination
      assert_raises(::FlatKit::Error) {
        ::FlatKit::Jsonl::Writer.new(destination: Object.new)
      }
    end

    def test_writes_to_pathname
      writer = ::FlatKit::Jsonl::Writer.new(destination: @write_path)
      @records.each do |r|
        writer.write(r)
      end
      writer.close
      assert_equal(@count, writer.count)

      expected = @dataset.records_as_jsonl
      actual = IO.read(@write_path)
      assert_equal(expected, actual)
    end

    def test_writes_to_io
      File.open(@write_path, "w+") do |f|
        writer = ::FlatKit::Jsonl::Writer.new(destination: f)

        @records.each do |r|
          writer.write(r)
        end
        writer.close

        assert_equal(@count, writer.count)

        expected = @dataset.records_as_jsonl
        actual = IO.read(@write_path)
        assert_equal(expected, actual)
      end
    end

    def test_raises_error_on_io_error
      s = StringIO.new
      s.close_write
      writer = ::FlatKit::Jsonl::Writer.new(destination: s)
      assert_raises(::FlatKit::Error) { writer.write(@records.first) }
    end
  end
end
