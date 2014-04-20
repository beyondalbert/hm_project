require 'typhoeus'
require 'json'

host = "http://localhost:3000"

(1..30).each do |j|
  (1..24).each do |i|
    res_record = Typhoeus::Request.post(host + "/api/records", params: {serial_num: "1234567890", temperature: "#{rand(40)}", pm25: "#{rand(400)}", formaldehyde: "#{rand(40)}", detect_time: "2014-04-#{j} #{i}"})
  end
end
