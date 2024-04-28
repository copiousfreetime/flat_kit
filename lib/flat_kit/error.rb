# frozen_string_literal: true

module FlatKit
  # Internal: A Base error class for all FlatKit errors
  #
  class Error < ::StandardError
    class UnknownFormat < ::FlatKit::Error; end
  end
end
