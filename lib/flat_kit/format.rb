module FlatKit
  class Format
    extend DescendantTracker

    def self.for(filename)
      find_child(:handles?, filename)
    end
  end
end
