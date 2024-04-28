# frozen_string_literal: true

module FlatKit
  class StatType
    def self.nominal_types
      [FieldType::BooleanType, FieldType::StringType, FieldType::NullType]
    end

    def self.ordinal_types
      [FieldType::DateType, FieldType::TimestampType]
    end

    def self.numerical_types
      [FieldType::FloatType, FieldType::IntegerType]
    end

    def self.for(type)
      return OrdinalStats   if ordinal_types.include?(type)
      return NominalStats   if nominal_types.include?(type)
      return NumericalStats if numerical_types.include?(type)

      raise ArgumentError, "Unknown stat type for #{type}"
    end

    def collected_stats
      raise NotImplementedError, "#{self.class.name} must implement #collected_stats"
    end

    #
    # call-seq:
    #   stat.to_hash   -> Hash
    #   stat.to_hash( %w[ count max mean ]) -> Hash
    #
    # return a hash of the stats.  By default this returns a hash of all stats
    # but passing in an array of items will limit the stats returned to only
    # those in the Array.
    #
    # If passed in an empty array or nil to to_hash then STATS is assumed to be
    # the list of stats to return in the hash.
    #
    def to_hash(*args)
      h = {}
      args = [args].flatten
      args = collected_stats if args.empty?
      args.each do |meth|
        h[meth] = send(meth)
      end
      h
    end

    #
    # call-seq:
    #   stat.to_json  -> String
    #   stat.to_json( *args ) -> String
    #
    # return a json string of the stats.  By default this returns a json string
    # of all the stats.  If an array of items is passed in, those that match the
    # known stats will be all that is included in the json output.
    #
    def to_json(*args)
      h = to_hash(*args)
      Oj.dump(h)
    end
  end
end
require "flat_kit/stat_type/nominal_stats"
require "flat_kit/stat_type/ordinal_stats"
require "flat_kit/stat_type/numerical_stats"
