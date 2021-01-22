module FlatKit
  class Error < ::StandardError
    class UnknownFormat < ::FlatKit::Error; end
  end
end
