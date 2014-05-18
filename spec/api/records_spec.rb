require 'spec_helper'

describe Records do
  before :each do
    @user = FactoryGirl.create :user, :with_api_token
  end
  describe "GET /api/records" do
    it "返回device今天的records" do
      @device = FactoryGirl.create :device, :with_today_records, serial_num: "123456", user_id: @user.id
      get "/api/records?api_token=#{@user.api_tokens.first.api_token}&device_id=#{@device.id}"
      JSON.parse(response.body).size.should == 5
    end

    it "返回device昨天的records" do
      @device = FactoryGirl.create :device, :with_yesterday_records, serial_num: "123456", user_id: @user.id
      get "/api/records?api_token=#{@user.api_tokens.first.api_token}&device_id=#{@device.id}&time_slot=yesterday"
      JSON.parse(response.body).size.should == 5
    end

    it "返回device前7天的日平均数据" do
      @device = FactoryGirl.create :device, :with_records, serial_num: "123456", user_id: @user.id
      get "/api/records?api_token=#{@user.api_tokens.first.api_token}&device_id=#{@device.id}&time_slot=last_week"
      JSON.parse(response.body).size.should == 3
    end

    it "返回device前一个月的日平均数据" do
      @device = FactoryGirl.create :device, :with_records, serial_num: "123456", user_id: @user.id
      get "/api/records?api_token=#{@user.api_tokens.first.api_token}&device_id=#{@device.id}&time_slot=last_month"
      JSON.parse(response.body).size.should == 4
    end

    it "返回device所有records的日平均数据" do
      @device = FactoryGirl.create :device, :with_records, serial_num: "123456", user_id: @user.id
      get "/api/records?api_token=#{@user.api_tokens.first.api_token}&device_id=#{@device.id}&time_slot=all"
      JSON.parse(response.body).size.should == 5
    end

    it "当api token无效时返回401" do
      get "/api/records"
      response.status.should == 500
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end

    it "用户无法获取其他人的device数据" do
      @device = FactoryGirl.create :device, :with_serial_num, user_id: @user.id
      @user_1 = FactoryGirl.create :user, :with_api_token_1
      get "/api/records?api_token=#{@user_1.api_tokens.first.api_token}&device_id=#{@device.id}"
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end
  end

  describe "POST /api/records" do
    it "创建一个record" do
      @device = FactoryGirl.create :device, :with_serial_num, user_id: @user.id
      expect {
        post "/api/records?api_token=#{@user.api_tokens.first.api_token}", serial_num: @device.serial_num, temperature: 26, pm25: 400, formaldehyde: 34, detect_time: "2014-05-17 1"
      }.to change(Record, :count).by(1)
      response.status.should == 201
    end
  end
end
