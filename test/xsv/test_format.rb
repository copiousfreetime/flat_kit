require_relative '../test_helper'

module TestXsv
  class TestFormat < ::Minitest::Test

    def test_handles_csv
      assert(::FlatKit::Xsv::Format.handles?("csv"))
    end

    def test_handles_tsv
      assert(::FlatKit::Xsv::Format.handles?("tsv"))
    end

    def test_handles_txt
      assert(::FlatKit::Xsv::Format.handles?("txt"))
    end

    def test_does_not_handle_json
      refute(::FlatKit::Xsv::Format.handles?("json"))
    end
  end
end
