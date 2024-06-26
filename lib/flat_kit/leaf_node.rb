# frozen_string_literal: true

module FlatKit
  # Private: The LeafNode is a wrapper around a Reader object to enable
  # a consistent api for use in the MergeTree
  #
  # The LeafNode keeps track of the head of the reader list and when its value
  # is used up, it pulls the next value and then notifies the next level of the
  # MergeTree that its value has changed and so should do another play.
  #
  # If all the data is used up from the reader, it also notifies the next level
  # of that so the next level can remove it from the tree.
  class LeafNode
    include Comparable

    attr_reader :reader, :value

    attr_accessor :next_level

    def initialize(reader)
      @reader     = reader
      @enum       = @reader.to_enum
      @value      = @enum.next

      @next_level = nil
    end

    def winner
      value
    end

    def sentinel?
      false
    end

    def leaf?
      true
    end

    def leaf
      self
    end

    def update_and_replay
      self.next
      if finished?
        ::FlatKit.logger.debug "#{reader.source} has finished reading #{reader.count} records"
        next_level.player_finished(self)
      end
      next_level.play
    end

    def next
      begin
        @value = @enum.next
      rescue StopIteration
        @value = nil
      end
      @value
    end

    def finished?
      @enum && @value.nil?
    end

    def <=>(other)
      return -1 if other.sentinel?

      value <=> (other.value)
    end
  end
end
