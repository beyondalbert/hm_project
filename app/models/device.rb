class Device < ActiveRecord::Base
  validates_presence_of :serial_num
  validates_uniqueness_of :serial_num

  has_many :records, dependent: :destroy

  def today_records
    records.select{|record| record.detect_time.to_date == Time.now.to_date}
  end

  def yesterday_records
    records.select{|record| record.detect_time.to_date == Time.now.yesterday.to_date}
  end

  def time_slot_records(time_slot)
    record_hash = {}
    tmp = []
    case time_slot
    when "week"
      ts_records = records.select{|record| record.detect_time.to_date > 1.week.ago.to_date}
    when "month"
      ts_records = records.select{|record| record.detect_time.to_date > 30.day.ago.to_date}
    when "all"
      ts_records = records
    end
    ts_records.each do |record|
      if tmp.include? record.detect_time.to_date
        record_hash[record.detect_time.to_date][:pm25] += record.pm25
        record_hash[record.detect_time.to_date][:temperature] += record.temperature
        record_hash[record.detect_time.to_date][:formaldehyde] += record.formaldehyde
        record_hash[record.detect_time.to_date][:count] += 1
      else
        tmp << record.detect_time.to_date
        record_hash[record.detect_time.to_date] = {pm25: record.pm25, temperature: record.temperature, formaldehyde: record.formaldehyde, count: 1}
      end
    end
    record_hash
  end
end
