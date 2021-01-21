require 'simplecov'
SimpleCov.start if ENV['COVERAGE']

require 'byebug'

require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'

require_relative '../lib/flat_kit'
require_relative './device_dataset'
