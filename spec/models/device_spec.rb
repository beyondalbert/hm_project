require 'spec_helper'

describe Device do
  it "没有serial_num无法创建" do
    FactoryGirl.build(:device).should_not be_valid
  end

  it "serial_num是独一无二的字段" do
    FactoryGirl.create(:device, serial_num: "123456")
    FactoryGirl.build(:device, serial_num: "123456").should_not be_valid
  end

  describe "#today_records" do
    it "返回设备今天的检测记录" do
      @device = FactoryGirl.create :device, :with_today_records, serial_num: "123456"
      @device.today_records.size.should == 5
    end
  end

  describe "#yesterday_records" do
    it "返回设别昨天的检测记录" do
      @device = FactoryGirl.create :device, :with_yesterday_records, serial_num: "123456"
      @device.yesterday_records.size.should == 5
    end
  end

  describe "#time_slot_records" do
    it "返回设别昨天的检测记录" do
      @device = FactoryGirl.create :device, :with_records, serial_num: "123456"
      @device.time_slot_records("week").size.should == 3
      @device.time_slot_records("month").size.should == 4
      @device.time_slot_records("all").size.should == 5
    end
  end

  describe "#current_status" do
    it "返回设备监测的最新的环境状态" do
      @device = FactoryGirl.create :device, :with_records, serial_num: "123456"
      @device.current_status.should eq "fine" 
    end
  end
end
