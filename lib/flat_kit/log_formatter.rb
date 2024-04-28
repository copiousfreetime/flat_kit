# frozen_string_literal: true

require "logger"

module FlatKit
  # Internal: Log formatting class for FlatKit
  #
  class LogFormatter < ::Logger::Formatter
    FORMAT          = "%s %5d %05s : %s\n"
    DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%SZ"
    def initialize
      super
      self.datetime_format = DATETIME_FORMAT
    end

    def call(severity, time, _progname, msg)
      format(FORMAT, format_datetime(time.utc), Process.pid, severity, msg2str(msg))
    end
  end
end
