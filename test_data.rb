require 'typhoeus'
require 'json'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: "localhost",
  username: "root",
  password: "",
  database: "hm_dev"
)

class Record < ActiveRecord::Base
end

if !Record.first.nil?
  Record.all.destroy_all
end

class Fixnum
  SECONDS_IN_DAY = 24 * 60 * 60
  def days
    self * SECONDS_IN_DAY
  end

  def ago
    Time.now - self
  end
end

host = "http://localhost:3000"
#host = "http://192.168.1.103"

(1..31).each do |j|
  (1..24).each do |i|
    res_record = Typhoeus::Request.post(host + "/api/records", params: {serial_num: "1234567890", temperature: "#{rand(40)}", pm25: "#{rand(400)}", formaldehyde: "#{rand(40)}", detect_time: "#{(31-j).days.ago.strftime('%F')} #{i}"})
    res_record = Typhoeus::Request.post(host + "/api/records", params: {serial_num: "1234567891", temperature: "#{rand(40)}", pm25: "#{rand(400)}", formaldehyde: "#{rand(40)}", detect_time: "#{(31-j).days.ago.strftime('%F')} #{i}"})
    res_record = Typhoeus::Request.post(host + "/api/records", params: {serial_num: "1234567892", temperature: "#{rand(40)}", pm25: "#{rand(400)}", formaldehyde: "#{rand(40)}", detect_time: "#{(31-j).days.ago.strftime('%F')} #{i}"})
    res_record = Typhoeus::Request.post(host + "/api/records", params: {serial_num: "1234567893", temperature: "#{rand(40)}", pm25: "#{rand(400)}", formaldehyde: "#{rand(40)}", detect_time: "#{(31-j).days.ago.strftime('%F')} #{i}"})
  end
end
