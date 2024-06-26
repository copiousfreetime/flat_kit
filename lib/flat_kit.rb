# frozen_string_literal: true

# Public: Top level namespace for this gem
#
module FlatKit
  VERSION = "1.0.0"
end
require "flat_kit/error"
require "flat_kit/descendant_tracker"
require "flat_kit/log_formatter"
require "flat_kit/logger"
require "flat_kit/event_emitter"

require "flat_kit/field_type"
require "flat_kit/format"
require "flat_kit/position"
require "flat_kit/record"
require "flat_kit/reader"
require "flat_kit/writer"
require "flat_kit/input"
require "flat_kit/output"
require "flat_kit/cli"
require "flat_kit/xsv"
require "flat_kit/jsonl"
require "flat_kit/merge"
require "flat_kit/sort"
require "flat_kit/stats"

require "flat_kit/stat_type"
require "flat_kit/field_stats"

require "flat_kit/merge_tree"
require "flat_kit/internal_node"
require "flat_kit/sentinel_internal_node"
require "flat_kit/sentinel_leaf_node"
require "flat_kit/leaf_node"
