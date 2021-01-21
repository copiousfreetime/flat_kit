require 'test_helper'

class TestMerge < ::Minitest::Test
  def test_can_use_stdout_as_output
    merge = ::FlatKit::Merge.new(inputs: [], output: $stdout, compare_keys: [])
    assert_match(/STDOUT/, merge.output.name)
    assert_instance_of(::FlatKit::Output::IO, merge.output)
  end

  def test_can_use_use_dash_as_output
    merge = ::FlatKit::Merge.new(inputs: [], output: "-", compare_keys: [])
    assert_match(/STDOUT/, merge.output.name)
    assert_instance_of(::FlatKit::Output::IO, merge.output)
  end

  def test_can_use_a_file_as_output
    test_path = "test_can_use_a_file_as_output.txt"
    begin
      File.open(test_path, "w") do |f|
        merge = ::FlatKit::Merge.new(inputs: [], output: f, compare_keys: [])
        assert_equal(test_path, merge.output.name)
        assert_instance_of(::FlatKit::Output::IO, merge.output)
      end
    ensure
      File.unlink(test_path)
    end
  end

  def test_can_use_a_text_path_as_output
    test_path = "tmp/test_can_use_a_text_path_as_output.txt"
    begin
      merge = ::FlatKit::Merge.new(output: test_path, inputs: [], compare_keys: [])
      assert_equal(test_path, merge.output.name)
      assert_instance_of(::FlatKit::Output::File, merge.output)
      merge.output.close
    ensure
      File.unlink(test_path) if File.exist?(test_path)
    end
  end

  def test_can_use_a_pathname_as_output
    test_path = Pathname.new("tmp/test_can_use_a_pathname_as_output.txt")
    begin
      merge = ::FlatKit::Merge.new(output: test_path, inputs: [], compare_keys: [])
      assert_equal(test_path.to_s, merge.output.name)
      assert_instance_of(::FlatKit::Output::File, merge.output)
      merge.output.close
    ensure
      test_path.unlink if test_path.exist?
    end
  end

  def test_raises_error_if_unable_to_parse_output
    test_path = Object.new
    assert_raises(FlatKit::Error) { ::FlatKit::Merge.new(output: test_path, inputs: [], compare_keys: []) }
  end
end
