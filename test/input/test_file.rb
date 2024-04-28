# frozen_string_literal: true

require_relative "../test_helper"

module TestInput
  class TestFile < ::Minitest::Test
    def test_does_not_handle_stdin_text
      ::FlatKit::Input::IO::STDINS.each do |e|
        refute(::FlatKit::Input::File.handles?(e), "#{e} is not stdin text")
      end
    end

    def test_handles_existing_file
      test_path = "tmp/test_handles_existing_file.txt"
      begin
        File.write(test_path, "test handles existing file")

        assert(::FlatKit::Input::File.handles?(test_path))
      ensure
        FileUtils.rm_f(test_path)
      end
    end

    def test_only_handles_string
      refute(::FlatKit::Input::File.handles?(Object.new))
    end

    def test_raises_error_if_not_readable
      assert_raises(FlatKit::Error) { ::FlatKit::Input::File.new("tmp/does-not-exist") }
    end

    def test_init_from_path
      test_path = "tmp/test_init_from_path.txt"
      begin
        File.write(test_path, "nothing to see here")
        io = ::FlatKit::Input::File.new(test_path)

        assert_equal(test_path, io.name)
        assert_instance_of(::File, io.io)
      ensure
        FileUtils.rm_f(test_path)
      end
    end

    def test_reads_from_file
      test_path = "tmp/test_reads_from_file.txt"
      begin
        text = "test_reads_from_file"
        File.write(test_path, text)

        input = ::FlatKit::Input::File.new(test_path)
        content = input.io.read

        assert_equal(text, content)

        input.close
      ensure
        FileUtils.rm_f(test_path)
      end
    end

    def test_reads_from_gzfile
      test_path = "tmp/test_reads_from_gzfile.txt.gz"
      begin
        text = "this is something to read"
        system("echo '#{text}' | gzip > #{test_path}")

        input = ::FlatKit::Input::File.new(test_path)
        content = input.io.read

        assert_equal(text + "\n", content)

        input.close
      ensure
        FileUtils.rm_f(test_path)
      end
    end
  end
end
