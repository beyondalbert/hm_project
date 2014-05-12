class Devices < Grape::API
  format :json
	content_type :json, 'application/json;charset=utf-8'
	
	before do
		@api_token = ApiToken.find_by_api_token(params[:api_token])
		@user = @api_token.user if @api_token
		unless @api_token
			error!({code: 401, msg: "该操作没有权限！"})
		end
	end

  resource :devices do
		desc "Get all user's devices"
    get do
			@user.devices
    end

		params do
			requires :id, type: Integer, desc: "device id"
		end
		route_param :id do
			before do
				@device = Device.find(params[:id])
				unless @device.user == @user
					error!({code: 401, msg: "该操作没有权限！"})
				end
			end

			desc "Return a devices"
			get do
				@device
			end

    	desc "Update a device"
    	put do
				@alias = params[:alias] ? params[:alias] : @device.alias
				@address = params[:address] ? params[:address] : @device.address
				@device.update(alias: @alias, address: @address)
				@device
    	end

    	desc "Delete a device"
			delete do
				if @device.destroy
					{code: 200, msg: "device 删除成功！"}
				end
			end
		end

    desc "Create a device"
    post do
			@device = Device.new(serial_num: params[:serial_num], alias: params[:alias], address: params[:address], user_id: @user.id)
			if @device.save
				@device
			else
				{code: 406, msg: "数据库存储失败！"}
			end
    end
  end
end
