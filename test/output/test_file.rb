require_relative '../test_helper'

module TestOutput
  class TestFile < ::Minitest::Test
    def test_does_not_handle_stderr_text
      ::FlatKit::Output::IO::STDERRS.each do |e|
        refute(::FlatKit::Output::File.handles?(e), "#{e} is not stderr text")
      end
    end

    def test_only_handles_string
      refute(::FlatKit::Output::File.handles?(Object.new))
    end

    def test_doest_not_handles_stdout_text
      ::FlatKit::Output::IO::STDOUTS.each do |e|
        refute(::FlatKit::Output::File.handles?(e), "#{e} is not stdout text")
      end
    end

    def test_init_from_path
      test_path = "tmp/test_init_from_path.txt"
      begin
        io = ::FlatKit::Output::File.new(test_path)
        assert_equal(test_path, io.name)
        assert_instance_of(::File, io.io)
      ensure
        File.unlink(test_path) if File.exist?(test_path)
      end
    end
  end
end
