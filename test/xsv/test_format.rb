require_relative '../test_helper'

module TestXsv
  class TestFormat < ::Minitest::Test

    def test_handles_csv
      assert(::FlatKit::Xsv::Format.handles?("csv"))
    end
  end
end
