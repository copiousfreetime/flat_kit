# frozen_string_literal: true

class DeviceDataset
  include TestHelper

  attr_reader :count, :compare_fields, :fields, :filename_jsonl, :filename_sorted_jsonl, :filename_csv,
              :filename_sorted_csv

  def initialize(count:, compare_fields: %w[manufacturer model_name slug])
    @count = count
    @compare_fields = compare_fields
    @fields = %w[
      build_number
      manufacturer
      model_name
      platform
      serial
      slug
    ]
    @filename_sorted_jsonl = nil
    @filename_jsonl = nil
    @filename_sorted_csv = nil
    @filename_csv = nil
    @slug = generate_slug
  end

  def persist_records_as_jsonl
    @filename_jsonl = scratch_file(prefix: "unsorted_", slug: @slug)
    @filename_jsonl.open("w+") do |f|
      f.write(records_as_jsonl)
    end
  end

  def persist_sorted_records_as_jsonl
    @filename_sorted_jsonl = scratch_file(prefix: "sorted_", slug: @slug)
    @filename_sorted_jsonl.open("w+") do |f|
      f.write(sorted_records_as_jsonl)
    end
  end

  def cleanup_files
    [@filename_sorted_jsonl, @filename_jsonl, @filename_sorted_csv, @filename_csv].each do |p|
      next if p.nil?

      p.unlink if p.exist?
    end
  end

  def records
    @records ||= [].tap do |a|
      count.times do
        a << {}.tap do |h|
          fields.each do |f|
            value = (f == "slug") ? generate_slug : ::Faker::Device.send(f)
            h[f] = value
          end
        end
      end
    end
  end

  def sorted_records
    @sorted_records ||= records.sort_by do |r|
      compare_fields.map { |field| r[field] }
    end
  end

  def records_as_jsonl
    @records_as_jsonl ||= as_jsonl(list: records)
  end

  def records_as_csv
    @records_as_csv ||= as_csv(list: records)
  end

  def records_as_csv_rows
    @records_as_csv_rows ||= as_csv_rows(records_as_csv)
  end

  def sorted_records_as_jsonl
    @sorted_records_as_jsonl ||= as_jsonl(list: sorted_records)
  end

  def sorted_records_as_csv
    @sorted_records_as_csv ||= as_csv(list: sorted_records)
  end

  def sorted_records_as_csv_rows
    @sorted_records_as_csv_rows ||= as_csv_rows(sorted_records_as_csv)
  end

  private

  def as_jsonl(list:)
    without_nl = list.map { |r| Oj.dump(r) }.join("\n")
    "#{without_nl}\n"
  end

  def as_csv(list:, headers: fields)
    CSV.generate(headers: headers, write_headers: true) do |csv|
      list.each do |r|
        csv << fields.map { |f| r[f] }
      end
    end
  end

  def as_csv_rows(text)
    [].tap do |a|
      CSV.new(text, converters: :numeric, headers: :first_row, return_headers: false).each do |row|
        a << row
      end
    end
  end
end
