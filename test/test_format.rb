# frozen_string_literal: true

require_relative "test_helper"

class TestFormat < ::Minitest::Test
  def test_finds_jsonl_format
    klass = ::FlatKit::Format.for("data.json.gz")

    assert_equal(::FlatKit::Jsonl::Format, klass)
  end

  def test_finds_xsv_format
    klass = ::FlatKit::Format.for("data.csv.gz")

    assert_equal(::FlatKit::Xsv::Format, klass)
  end

  def test_finds_jsonl_format_for_full_path
    klass = ::FlatKit::Format.for("tmp/sorted/foo.jsonl")

    assert_equal(::FlatKit::Jsonl::Format, klass)
  end

  def test_finds_jsonl_format_with_fallback
    path = "tmp/sorted/foo.json"
    klass = ::FlatKit::Format.for_with_fallback!(path: path, fallback: "auto")

    assert_equal(::FlatKit::Jsonl::Format, klass)
  end
end
