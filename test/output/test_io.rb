require_relative '../test_helper'

module TestOutput
  class TestIO < ::Minitest::Test
    def test_handles_stderr_text
      ::FlatKit::Output::IO::STDERRS.each do |e|
        assert(::FlatKit::Output::IO.handles?(e), "#{e} is not stderr text")
      end
    end

    def test_handles_stderr_io
      x = $stderr
      assert(::FlatKit::Output::IO.handles?(x), "is not stderr")
    end

    def test_handles_stdout_text
      ::FlatKit::Output::IO::STDOUTS.each do |e|
        assert(::FlatKit::Output::IO.handles?(e), "#{e} is not stdout text")
      end
    end

    def test_handles_stdout_io
      x = $stderr
      assert(::FlatKit::Output::IO.handles?(x), "is not stdout")
    end

    def test_does_not_handle_other
      x = Object.new
      refute(::FlatKit::Output::IO.handles?(x))
    end

    def test_init_from_dash
      io = ::FlatKit::Output::IO.new("-")
      assert_equal("<STDOUT>", io.name)
      assert_equal(::STDOUT, io.io)
    end

    def test_init_from_stderr_text
      io = ::FlatKit::Output::IO.new("stderr")
      assert_equal("<STDERR>", io.name)
      assert_equal(::STDERR, io.io)
    end

    def test_init_from_file_object
      test_path = "tmp/test_init_from_file_object.txt"
      begin
        File.open(test_path, "w") do |f|
          io = ::FlatKit::Output::IO.new(f)
          assert_equal(test_path, io.name)
          assert_instance_of(::File, io.io)
        end
      ensure
        File.unlink(test_path) if File.exist?(test_path)
      end
    end

    def test_init_from_stdout
      io  = ::FlatKit::Output::IO.new($stdout)
      assert_equal("<STDOUT>", io.name)
      assert_equal(::STDOUT, io.io)
    end


    def test_writes_to_io
      test_path = "tmp/test_writes_to_io.txt"
      begin
        File.open(test_path, "w") do |f|
          io = ::FlatKit::Output::IO.new(f)
          assert_equal(test_path, io.name)
          assert_instance_of(::File, io.io)
          io.write("test_writes_to_io output")
          io.close
          assert_equal(1, io.count)
        end
        t = IO.read(test_path)
        assert_equal("test_writes_to_io output", t)
      ensure
        File.unlink(test_path) if File.exist?(test_path)
      end
    end

  end
end
