#!/usr/bin/env
# frozen_string_literal: true

#------------------------------------------------------------------------------
# This is an example to show how to stream an active record scope to a CSV file
# using FlatKit.
#------------------------------------------------------------------------------

require "flat_kit"     # gem 'flat_kit'
require "progress_bar" # gem 'progress-bar'

# get an appropriate scope from one of your models - or any scope for that
# matter
scope      = MyActiveRecordModel.all

# Output to a file that is csv, and automatically gzipped
#
output_csv = FlatKit::Xsv::Writer.new(destination: "export.csv.gz")

# handy progress bar
bar        = ProgressBar.new(scope.count)

# using active record in batches to not pull all the recors from the database at
# once
#
#  https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each
scope.find_each do |record|
  # generate an XSV Record by pulling hte attributes out of the active record
  # model. You may also want to generate a hash from a query or something
  # along those lines. In any case pass in a Hash to complete_structured_data:
  # and nil to data.
  xsv_record = FlatKit::Xsv::Record.new(data: nil, complete_structured_data: record.attributes)

  # FlatKit will automatically handle writing out the header line based upon
  # the fields in the first record.
  output_csv.write(xsv_record)

  bar.increment!
end

# close the output file explicitly
output_csv.close
