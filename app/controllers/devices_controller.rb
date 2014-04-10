class DevicesController < ApplicationController
  before_action :find_device, only: [:edit, :update, :destroy]

  def index
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
