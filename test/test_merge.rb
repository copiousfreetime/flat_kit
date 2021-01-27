require 'test_helper'

class TestMerge < ::Minitest::Test

  def test_can_use_use_dash_as_output
    merge = ::FlatKit::Merge.new(inputs: [], input_fallback: "json",
                                 output: "-", output_fallback: "json", compare_fields: [])
    assert_match(/STDOUT/, merge.writer.output.name)
    assert_instance_of(::FlatKit::Output::IO, merge.writer.output)
  end

  def test_can_use_a_text_path_as_output
    test_path = "tmp/test_can_use_a_text_path_as_output.json"
    begin
      merge = ::FlatKit::Merge.new(output: test_path, inputs: [], input_fallback: "json",  compare_fields: [])
      assert_equal(test_path, merge.writer.output.name)
      assert_instance_of(::FlatKit::Output::File, merge.writer.output)
      merge.writer.close
    ensure
      File.unlink(test_path) if File.exist?(test_path)
    end
  end

  def test_can_use_a_pathname_as_output
    test_path = Pathname.new("tmp/test_can_use_a_pathname_as_output.json")
    begin
      merge = ::FlatKit::Merge.new(output: test_path, inputs: [], input_fallback: "json", compare_fields: [])
      assert_equal(test_path.to_s, merge.writer.output.name)
      assert_instance_of(::FlatKit::Output::File, merge.writer.output)
      merge.writer.close
    ensure
      test_path.unlink if test_path.exist?
    end
  end

  def test_raises_error_if_unable_to_parse_output
    test_path = Object.new
    assert_raises(FlatKit::Error) { ::FlatKit::Merge.new(output: test_path, inputs: [], compare_fields: []) }
  end
end
