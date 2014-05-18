require 'spec_helper'

describe Devices do
  before :each do
    @user = FactoryGirl.create :user, :with_api_token
  end
  describe "GET /api/devices" do
    it "返回用户的devices json数据" do
      @device = FactoryGirl.create :device, :with_serial_num, user_id: @user.id
      get "/api/devices?api_token=#{@user.api_tokens.first.api_token}"
      response.status.should == 200
      JSON.parse(response.body).first.except('created_at', 'updated_at').should eq @device.attributes.except('created_at', 'updated_at')
    end

    it "当api token无效时返回401" do
      get "/api/devices?api_token=1234"
      response.status.should == 500
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end
  end

  describe "GET /api/devices/:id" do
    before :each do
      @device = FactoryGirl.create :device, :with_serial_num, user_id: @user.id
    end
    it "返回指定的devices信息" do
      get "/api/devices/#{@device.id}?api_token=#{@user.api_tokens.first.api_token}"
      JSON.parse(response.body).except('created_at', 'updated_at').should eq @device.attributes.except('created_at', 'updated_at')
    end

    it "当api token无效时返回401" do
      get "/api/devices/#{@device.id}"
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end

    it "当@device不属于该用户时，返回401" do
      @user_1 = FactoryGirl.create :user, :with_api_token_1
      get "/api/devices/#{@device.id}?api_token=#{@user_1.api_tokens.first.api_token}"
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end
  end

  describe "#PUT /api/deives/:id" do
    before :each do
      @device = FactoryGirl.create :device, :with_serial_num, user_id: @user.id
    end
    it "返回更新后的device" do
      put "/api/devices/#{@device.id}?api_token=#{@user.api_tokens.first.api_token}", alias: "test_put", address: "test_put"

      JSON.parse(response.body)["alias"].should eq "test_put"
      JSON.parse(response.body)["address"].should eq "test_put"
    end

    it "当api token无效时返回401" do
      put "/api/devices/#{@device.id}", alias: "test_put", address: "test_put"
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end

    it "当@device不属于该用户时，返回401" do
      @user_1 = FactoryGirl.create :user, :with_api_token_1
      put "/api/devices/#{@device.id}?api_token=#{@user_1.api_tokens.first.api_token}", alias: "test_put", address: "test_put"
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end
  end

  describe "DELETE /api/devices/:id" do
    before :each do
      @device = FactoryGirl.create :device, :with_serial_num, user_id: @user.id
    end
    it "删除一个device" do
      expect{
        delete "/api/devices/#{@device.id}?api_token=#{@user.api_tokens.first.api_token}"
      }.to change(Device, :count).by(-1)
      JSON.parse(response.body).should == {"code" => 200, "msg" => "device 删除成功！"}
    end

    it "当api token无效时返回401, device无法被删除" do
      expect{
        delete "/api/devices/#{@device.id}"
      }.to_not change(Device, :count)
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end

    it "当@device不属于该用户时，返回401, device无法被删除" do
      @user_1 = FactoryGirl.create :user, :with_api_token_1
      expect {
        delete "/api/devices/#{@device.id}?api_token=#{@user_1.api_tokens.first.api_token}"
      }.to_not change(Device, :count)
      JSON.parse(response.body).should == {"code"=>401, "msg"=>"该操作没有权限！"}
    end
  end

  describe "POST /api/devices" do
    it "创建一个device" do
      expect {
        post "/api/devices?api_token=#{@user.api_tokens.first.api_token}", serial_num: "1234567890spectest", alias: "test_post", address: "test_post"
      }.to change(Device, :count).by(1)
      response.status.should == 201
    end

    it "当device参数非法时，无法创建device的" do
      expect {
        post "/api/devices?api_token=#{@user.api_tokens.first.api_token}", alias: "test_post", address: "test_post"
      }.to_not change(Device, :count)
      JSON.parse(response.body).should == {"code"=>406, "msg"=>"数据库存储失败！"}
    end
  end
end
