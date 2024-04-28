# frozen_string_literal: true

require "logger"

# Public: Top level namespace for the gem
#
module FlatKit
  # Internal: Logger class
  #
  class Logger
    def self.for_io(io)
      ::Logger.new(io, formatter: LogFormatter.new)
    end

    def self.for_path(path)
      io = File.open(path.to_s, "a")
      for_io(io)
    end
  end

  def self.log_to(destination = $stderr)
    @logger = if destination.is_a?(::IO)
                ::FlatKit::Logger.for_io(destination)
              else
                ::FlatKit::Logger.for_path(destination)
              end
  end

  def self.logger
    @logger ||= ::FlatKit::Logger.for_io($stderr)
  end
end
