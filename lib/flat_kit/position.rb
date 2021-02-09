module FlatKit
  # The information about the position of a record in an IO stream
  #
  # Generally this is going to be returned by a write_record method to return
  # information about the record that was just written
  #
  class Position

    attr_reader :index    # zero based
    attr_reader :offset   # byte offset in the IO stream
    attr_reader :bytesize # byte length of the record

    def initialize(index: nil, offset: nil, bytesize: nil)
      @index    = index
      @offset   = offset
      @bytesize = bytesize
    end
  end
end
