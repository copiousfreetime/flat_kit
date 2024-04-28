# frozen_string_literal: true

require_relative "../test_helper"

module TestJsonl
  class TestFormat < ::Minitest::Test
    def test_handles_json
      assert(::FlatKit::Jsonl::Format.handles?("data.json.gz"))
    end

    def test_handles_jsonl
      assert(::FlatKit::Jsonl::Format.handles?("data.jsonl"))
    end

    def test_handles_ndjson
      assert(::FlatKit::Jsonl::Format.handles?("log.ndjson"))
    end

    def test_does_not_handle_csv
      refute(::FlatKit::Jsonl::Format.handles?("data.csv"))
    end
  end
end
