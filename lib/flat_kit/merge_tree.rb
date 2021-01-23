module FlatKit
  class MergeTree
    attr_reader :nodes

    def initialize
      @nodes = []
    end

    def add_reader(reader)
      ::FlatKit.logger.info "Added reader #{reader.source}"
      @nodes << MergeNode.new(reader)
    end

    def each
      while nodes.any? do
        #nodes.sort!
        head = nodes.shift
        record = head.current
        if head.next then
          nodes.push(head)
        else
          ::FlatKit.logger.info "dropping #{head.reader.source} from the tree"
        end
        yield record
      end
    end
  end
end
