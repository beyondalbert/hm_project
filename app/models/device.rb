class Device < ActiveRecord::Base
  validates_presence_of :serial_num
  validates_uniqueness_of :serial_num

  has_many :records, dependent: :destroy
  has_many :watchers, dependent: :destroy
  belongs_to :user

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

  def latest_record
    records.last
  end

  def box_background_color
    case current_status
    when "excellent"
      "panel-success"
    when "fine"
      "panel-info"
    when "ok"
      "panel-primary"
    when "bad"
      "panel-warning"
    when "worse"
      "panel-danger"
    else
      "panel-default"
    end
  end

  def current_status_rate
    case current_status
    when "excellent"
      5 
    when "fine"
      4
    when "ok"
      3
    when "bad"
      2
    when "worse"
      1
    else
      0
    end
  end

  def current_status
    if latest_record
      t = latest_record.temperature
      if t > 40 || t < -5
        "worse"
      elsif (t >= -5 && t < 5) || (t >= 35 && t < 40)
        "bad"
      elsif (t >= 5 && t < 15) || (t >= 30 && t < 35)
        "ok"
      elsif (t >= 15 && t < 20) || (t >=25 && t < 30)
        "fine"
      else
        "excellent"
      end
    else
      "non-result"
    end
  end
end
