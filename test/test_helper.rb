# frozen_string_literal: true

require "simplecov"
if ENV["COVERAGE"]
  SimpleCov.start do
    enable_coverage :branch
    primary_coverage :line
    add_filter %r{^/(test|spec)/}
  end
end

require "debug"

require "minitest/autorun"
require "minitest/focus"
require "minitest/pride"

module TestHelper
  def scratch_dir
    p = Pathname.new(__FILE__).parent.parent.join("tmp/testing_scratch")
    p.mkpath
    p
  end

  def generate_slug(length: 10)
    SecureRandom.alphanumeric(length)
  end

  def scratch_file(prefix: "test_", slug: generate_slug, extension: ".jsonl")
    scratch_dir.join("#{prefix}#{slug}#{extension}")
  end
end
require "flat_kit"
require_relative "device_dataset"
