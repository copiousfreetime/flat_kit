module FlatKit
  class Format
    extend DescendantTracker

    def self.format_name
      raise NotImplementedError, "#{self.class} must implemente #{self.class}.format_name"
    end

    def format_name
      self.class.format_name
    end

    def self.for(filename)
      find_child(:handles?, filename)
    end
  end
end
