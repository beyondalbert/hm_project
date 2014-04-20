class DevicesController < ApplicationController
  before_action :find_device, only: [:edit, :update, :destroy, :show]

  def index
  end

  def show
    @pm25 = []
    @temperature = []
    @formaldehyde = []
    @x_axis = []
    @time_slot = params[:time_slot]
    @start = 0
    case params[:time_slot]
    when "yesterday"
      @records = @device.yesterday_records
    when "last_week"
      @records = @device.time_slot_records("week")
    when "last_month"
      @records = @device.time_slot_records("month")
      @start = 40
    when "all"
      @records = @device.time_slot_records("all")
      @start = 60
    else
      @records = @device.today_records
    end

    if ["last_week", "last_month", "all"].include? @time_slot
      @records.each_pair do |key, value|
        @x_axis << key.strftime("%F")
        @pm25 << value[:pm25]/value[:count]
        @temperature << value[:temperature]/value[:count]
        @formaldehyde << value[:formaldehyde]/value[:count]
      end
    else
      @records.each do |record|
        @pm25 << record.pm25
        @temperature << record.temperature
        @formaldehyde << record.formaldehyde
        @x_axis << record.detect_time.strftime("%F %H")
      end
    end
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)
    @device.user_id = current_user.id
    if @device.save
      redirect_to devices_path, flash: { success: "监测设备创建成功！" }
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @device.update(device_params)
      redirect_to devices_path, flash: { success: "监测设备更新成功！" }
    else
      render "edit"
    end
  end

  def destroy
    @device.destroy
    redirect_to devices_path, flash: { success: "监测设备删除成功！" }
  end

  private

  def device_params
    params.require(:device).permit(:serial_num, :alias, :address)
  end

  def find_device
    @device = Device.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
