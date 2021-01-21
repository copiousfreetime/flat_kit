class DeviceDataset

  attr_reader :count
  attr_reader :records
  attr_reader :compare_fields
  attr_reader :fields

  def initialize(count:, compare_fields: [ "manufacturer", "model_name" ])
    @count = count
    @compare_fields = compare_fields
    @fields = %w[
      build_number
      manufacturer
      model_name
      platform
      serial
      version
    ]
  end

  def records
    @records ||= Array.new.tap do |a|
      count.times do
        a << Hash.new.tap do |h|
          fields.each do |f|
            h[f] = ::Faker::Device.send(f)
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
    @jsonl_records ||= as_jsonl(list: records)
  end

  def records_as_csv
    @csv_records ||= as_csv(list: records)
  end

  def records_as_csv_rows
    @csv_rows ||= as_csv_rows(records_as_csv)
  end

  def sorted_records_as_jsonl
    @jsonl_sorted_records ||= as_jsonl(list: sorted_records)
  end

  def sorted_records_as_csv
    @csv_sorted_records ||= as_csv(list: sorted_records)
  end

  def sorted_records_as_csv_rows
    @csv_sorted_rows ||= as_csv_rows(sorted_records_as_csv)
  end

  private

  def as_jsonl(list:)
    list.map { |r| Oj.dump(r) }.join("\n") + "\n"
  end

  def as_csv(list:, headers: fields)
    CSV.generate('', headers: headers , write_headers: true) do |csv|
      list.each do |r|
        csv << fields.map { |f| r[f] }
      end
    end
  end

  def as_csv_rows(text)
    Array.new.tap do |a|
      CSV.new(text, converters: :numeric, headers: :first_row, return_headers: false).each do |row|
        a << row
      end
    end
  end
end
