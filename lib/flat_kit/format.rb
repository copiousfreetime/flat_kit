# frozen_string_literal: true

module FlatKit
  # Internal: The base class of all data file format classes
  #
  class Format
    extend DescendantTracker

    def self.format_name
      raise NotImplementedError, "#{self.class} must implement #{self.class}.format_name"
    end

    def format_name
      self.class.format_name
    end

    def self.for(path)
      find_child(:handles?, path.to_s)
    end

    def self.for_with_fallback(path:, fallback: "auto")
      # test by path
      format = ::FlatKit::Format.for(path)
      return format unless format.nil?

      # now try the fallback
      ::FlatKit::Format.for(fallback)
    end

    def self.for_with_fallback!(path:, fallback: "auto")
      format = for_with_fallback(path: path, fallback: fallback)
      if format.nil?
        raise ::FlatKit::Error::UnknownFormat,
              "Unable to figure out format for '#{path}' with fallback '#{fallback}'"
      end

      format
    end
  end
end
