module FlatKit
  # The information about the position of a record in an IO stream
  #
  # Generally this is going to be returned by a write_record method to return
  # information about the record that was just written
  #
  class Position
    attr_reader :index, :offset, :bytesize # zero based   # byte offset in the IO stream # byte length of the record

    def initialize(index: nil, offset: nil, bytesize: nil)
      @index    = index
      @offset   = offset
      @bytesize = bytesize
    end
  end
end
