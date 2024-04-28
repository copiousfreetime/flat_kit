# frozen_string_literal: true

require_relative "../test_helper"

module TestXsv
  class TestWriter < ::Minitest::Test
    def setup
      @count = 20
      @dataset = DeviceDataset.new(count: @count)
      @compare_fields = @dataset.compare_fields
      @write_path = "tmp/test_writes_to_io.csv"
      @read_path = "tmp/test_read.csv"

      File.open(@read_path, "wb") do |f|
        f.write(@dataset.records_as_csv)
      end

      @reader = ::FlatKit::Xsv::Reader.new(source: @read_path, compare_fields: @compare_fields)
      @records = @reader.to_a
    end

    def teardown
      FileUtils.rm_f(@write_path)
      FileUtils.rm_f(@read_path)
    end

    def test_raises_error_on_invalid_destination
      assert_raises(::FlatKit::Error) do
        ::FlatKit::Xsv::Writer.new(destination: Object.new, fields: @reader.fields)
      end
    end

    def test_writes_to_pathname
      writer = ::FlatKit::Xsv::Writer.new(destination: @write_path, fields: @reader.fields)
      @records.each do |r|
        writer.write(r)
      end
      writer.close

      assert_equal(@count, writer.count)

      expected = @dataset.records_as_csv
      actual = File.read(@write_path)

      assert_equal(expected, actual)
    end

    def test_position
      File.open(@write_path, "w+") do |f|
        writer = ::FlatKit::Xsv::Writer.new(destination: f, fields: :auto)
        records_bytes = 0
        header_bytes = nil

        @records.each_with_index do |r, idx|
          record_length = r.to_s.bytesize

          position = writer.write(r)
          # make sure write stores the last_position api and returns that value
          assert_equal(position, writer.last_position)

          header_bytes = writer.header_bytes if header_bytes == nil

          assert(header_bytes > 0)

          assert_equal(idx, position.index)
          assert_equal(header_bytes + records_bytes, position.offset)
          assert_equal(record_length, position.bytesize)

          records_bytes += record_length

          current_position = writer.current_position

          assert_equal(idx + 1, current_position.index)
          assert_equal(header_bytes + records_bytes, current_position.offset)
          assert_equal(0, current_position.bytesize)
        end
        writer.close

        assert_equal(@count, writer.count)

        expected = @dataset.records_as_csv
        actual = File.read(@write_path)

        assert_equal(expected, actual)
      end
    end

    def test_raises_error_on_io_error
      s = StringIO.new
      writer = ::FlatKit::Xsv::Writer.new(destination: s, fields: @reader.fields)
      s.close_write
      assert_raises(::FlatKit::Error) { writer.write(@records.first) }
    end
  end
end
