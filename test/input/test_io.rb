# frozen_string_literal: true

require_relative "../test_helper"

module TestInput
  class NullIO < ::IO
    def initialize()
    end
  end

  class TestIO < ::Minitest::Test
    def test_handles_stdin_text
      ::FlatKit::Input::IO::STDINS.each do |e|
        assert(::FlatKit::Input::IO.handles?(e), "#{e} is not stdin text")
      end
    end

    def test_handles_stdin_io
      x = $stdin

      assert(::FlatKit::Input::IO.handles?(x), "is not stdin")
    end

    def test_handles_stringio
      assert(::FlatKit::Input::IO.handles?(StringIO.new))
    end

    def test_does_not_handle_other
      x = Object.new

      refute(::FlatKit::Input::IO.handles?(x))
    end

    def test_init_from_dash
      io = ::FlatKit::Input::IO.new("-")

      assert_equal("<STDIN>", io.name)
      assert_equal(::STDIN, io.io)
    end

    def test_init_from_file_object
      test_path = "tmp/test_init_from_file_object.txt"
      begin
        File.open(test_path, "w+") do |f|
          io = ::FlatKit::Input::IO.new(f)

          assert_equal(test_path, io.name)
          assert_instance_of(::File, io.io)
        end
      ensure
        FileUtils.rm_f(test_path)
      end
    end

    def test_init_from_string_io_object
      sio = StringIO.new
      io = ::FlatKit::Input::IO.new(sio)

      assert_match(/StringIO/, io.name)
      assert_instance_of(::StringIO, io.io)
    end

    def test_init_from_io_object
      null_io = NullIO.new
      io = ::FlatKit::Input::IO.new(null_io)

      assert_match(/NullIO/, io.name)
      assert_instance_of(::TestInput::NullIO, io.io)
    end

    def test_init_from_stdin
      io  = ::FlatKit::Input::IO.new($stdin)

      assert_equal("<STDIN>", io.name)
      assert_equal(::STDIN, io.io)
    end

    def test_init_from_invalid
      assert_raises(::FlatKit::Error) { ::FlatKit::Input::IO.new(Object.new) }
    end

    def test_reads_from_io
      test_path = "tmp/test_reads_from_io.txt"
      begin
        line = "This is a line to read"
        File.open(test_path, "w+") do |f|
          f.write(line)
          f.rewind

          io = ::FlatKit::Input::IO.new(f)
          content = io.io.read
          io.close

          assert_equal(content, line)
        end
      ensure
        FileUtils.rm_f(test_path)
      end
    end
  end
end
