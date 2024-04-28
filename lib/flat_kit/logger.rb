# frozen_string_literal: true

require "logger"

module FlatKit
  class LogFormatter < ::Logger::Formatter
    FORMAT          = "%s %5d %05s : %s\n"
    DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%SZ"
    def initialize
      super
      self.datetime_format = DATETIME_FORMAT
    end

    def call(severity, time, progname, msg)
      FORMAT % [format_datetime(time.utc), Process.pid, severity, msg2str(msg)]
    end
  end

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
    if destination.kind_of?(::IO) then
      @logger = ::FlatKit::Logger.for_io(destination)
    else
      @logger = ::FlatKit::Logger.for_path(destination)
    end
  end

  def self.logger
    @logger ||= ::FlatKit::Logger.for_io($stderr)
  end
end
