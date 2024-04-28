# frozen_string_literal: true

#--
# Copyright (c) 2008, 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#
# Pulled from Hitimes, which I also wrote
#++

require "thread"
require "oj"

module FlatKit
  class StatType
    #
    # Stats object will keep track of the _min_, _max_, _count_, _sum_ and _sumsq_
    # and when you want you may also retrieve the _mean_, _stddev_ and _rate_.
    #
    # this contrived example shows getting a list of all the files in a directory
    # and running stats on file sizes.
    #
    #     s = FlatKit::Stats.new
    #     dir = ARGV.shift || Dir.pwd
    #     Dir.entries( dir ).each do |entry|
    #       fs = File.stat( entry )
    #       if fs.file? then
    #         s.update( fs.size )
    #        end
    #     end
    #
    #     %w[ count min max mean sum stddev rate ].each do |m|
    #       puts "#{m.rjust(6)} : #{s.send( m ) }"
    #     end
    #
    class NumericalStats < NominalStats
      # A list of the available stats

      attr_reader :min, :max, :sum, :sumsq

      def self.default_stats
        @default_stats ||= %w[count max mean min rate stddev sum sumsq]
      end

      def self.all_stats
        @all_stats ||= %w[count max mean min mode rate stddev sum sumsq unique_count unique_values]
      end

      def initialize(collecting_frequencies: false)
        super
        @min = Float::INFINITY
        @max = -Float::INFINITY
        @sum = 0.0
        @sumsq = 0.0
      end

      # call-seq:
      #    stat.update( val ) -> val
      #
      # Update the running stats with the new value.
      # Return the input value.
      def update(value)
        @mutex.synchronize do
          @min = [value, @min].min
          @max = [value, @max].max

          @count += 1
          @sum   += value
          @sumsq += (value * value)

          # from Nomnial update
          @frequencies[value] += 1 if @collecting_frequencies
        end

        value
      end

      # call-seq:
      #    stat.mean -> Float
      #
      # Return the arithmetic mean of the values put into the Stats object.  If no
      # values have passed through the stats object then 0.0 is returned;
      def mean
        return 0.0 if @count.zero?

        @sum / @count
      end

      # call-seq:
      #    stat.rate -> Float
      #
      # Return the +count+ divided by +sum+.
      #
      # In many cases when Stats#update( _value_ ) is called, the _value_ is a unit
      # of time, typically seconds or microseconds.  #rate is a convenience for those
      # times.  In this case, where _value_ is a unit if time, then count divided by
      # sum is a useful value, i.e. +something per unit of time+.
      #
      # In the case where _value_ is a non-time related value, then the value
      # returned by _rate_ is not really useful.
      #
      def rate
        return 0.0 if @sum.zero?

        @count / @sum
      end

      #
      # call-seq:
      #    stat.stddev -> Float
      #
      # Return the standard deviation of all the values that have passed through the
      # Stats object.  The standard deviation has no meaning unless the count is > 1,
      # therefore if the current _stat.count_ is < 1 then 0.0 will be returned;
      #
      def stddev
        return 0.0 unless @count > 1

        Math.sqrt((@sumsq - ((@sum * @sum) / @count)) / (@count - 1))
      end
    end
  end
end
