require 'set'

module FlatKit
  module DescendantTracker
    def inherited(klass)
      super
      return unless klass.instance_of?(Class)
      self.children << klass
    end

    def children
      unless defined? @_children
        @_children = Set.new
      end
      @_children
    end

    #
    # Find the first child that returns truthy from the given method with args
    #
    def find_child(method, *args)
      children.find do |child_klass|
        child_klass.send(method, *args)
      end
    end
  end
end
