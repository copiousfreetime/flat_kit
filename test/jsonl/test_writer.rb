# frozen_string_literal: true

require_relative "../test_helper"

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
      FileUtils.rm_f(@write_path)
      FileUtils.rm_f(@read_path)
    end

    def test_raises_error_on_invalid_destination
      assert_raises(::FlatKit::Error) do
        ::FlatKit::Jsonl::Writer.new(destination: Object.new)
      end
    end

    def test_writes_to_pathname
      writer = ::FlatKit::Jsonl::Writer.new(destination: @write_path)
      @records.each do |r|
        writer.write(r)
      end
      writer.close

      assert_equal(@count, writer.count)

      expected = @dataset.records_as_jsonl
      actual = File.read(@write_path)

      assert_equal(expected, actual)
    end

    def test_postion
      File.open(@write_path, "w+") do |f|
        writer = ::FlatKit::Jsonl::Writer.new(destination: f)

        byte_offset = 0
        @records.each_with_index do |r, idx|
          record_length = r.data.bytesize

          position = writer.write(r)

          # make sure write stores the last_position api and returns that value
          assert_equal(position, writer.last_position)

          assert_equal(idx, position.index)
          assert_equal(byte_offset, position.offset)
          assert_equal(record_length, position.bytesize)

          byte_offset += record_length

          current_position = writer.current_position

          assert_equal(idx + 1, current_position.index)
          assert_equal(byte_offset, current_position.offset)
          assert_equal(0, current_position.bytesize)
        end
        writer.close

        assert_equal(@count, writer.count)

        expected = @dataset.records_as_jsonl
        actual = File.read(@write_path)

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
