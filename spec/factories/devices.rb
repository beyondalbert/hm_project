FactoryGirl.define do
  factory :device do
    address "test-address"
  end

  trait :with_serial_num do
    serial_num "123456789test"
  end

  trait :with_today_records do
    after :create do |device|
      FactoryGirl.create_list :record, 5, detect_time: "#{Time.now.strftime('%F')} 1", device: device
    end
  end

  trait :with_yesterday_records do
    after :create do |device|
      FactoryGirl.create_list :record, 5, detect_time: "#{Time.now.yesterday.strftime('%F')} 1", device: device
    end
  end

  trait :with_records do
    after :create do |device|
      FactoryGirl.create_list :record, 5, detect_time: "#{Time.now.strftime('%F')} 1", device: device
      FactoryGirl.create_list :record, 5, detect_time: "#{Time.now.yesterday.strftime('%F')} 1", device: device
      FactoryGirl.create_list :record, 5, detect_time: "#{5.days.ago.strftime('%F')} 1", device: device
      FactoryGirl.create_list :record, 5, detect_time: "#{8.days.ago.strftime('%F')} 1", device: device
      FactoryGirl.create_list :record, 5, detect_time: "#{36.days.ago.strftime('%F')} 1", device: device
    end
  end
end
