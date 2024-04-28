# frozen_string_literal: true

require "test_helper"

class TestVersion < Minitest::Test
  def test_version_constant_match
    assert_match(/\A\d+\.\d+\.\d+\Z/, FlatKit::VERSION)
  end

  def test_version_string_match
    assert_match(/\A\d+\.\d+\.\d+\Z/, FlatKit::VERSION.to_s)
  end
end
