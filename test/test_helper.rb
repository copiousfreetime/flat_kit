require 'simplecov'
SimpleCov.start if ENV['COVERAGE']

require 'byebug'

require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'

module TestHelper
  def scratch_dir
    p = Pathname.new(__FILE__).parent.parent.join('tmp/testing_scratch')
    p.mkpath
    p
  end

  def generate_slug(length: 10)
    SecureRandom.alphanumeric(10)
  end

  def scratch_file(prefix: "test_", slug: generate_slug, extension: ".jsonl")
    scratch_dir.join("#{prefix}#{slug}#{extension}")
  end
end
require_relative '../lib/flat_kit'
require_relative './device_dataset'
