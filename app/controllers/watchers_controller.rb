class WatchersController < ApplicationController
  def create
    @watcher = Watcher.new(device_id: params[:watcher][:device_id])
    @user = User.where(email: params[:watcher][:email]).first
    @watcher.user_id = @user.id
    if @watcher.save
      flash[:success] = "添加检测器关注者成功！"
    else
      flash[:alert] = "添加检测器关注者失败！"
      @watcher.errors.full_messages.each do |m|
        flash[:alert] += "<li>#{m}</li>"
      end
    end
    redirect_to devices_path(@watcher.device_id)
  end

  def destroy
    @watcher = Watcher.find(params[:id])
    @watcher.destroy
    flash[:success] = "删除关注者成功！"
    redirect_to device_path(@watcher.device_id)
  end
end
