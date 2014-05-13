class Records < Grape::API
	format :json
	resource :records do
		get :hello do
			{hello: "world"}
		end

		desc "get device's data"
		get do
			@api_token = ApiToken.find_by_api_token(params[:api_token])
			@user = @api_token.user if @api_token
			unless @api_token
				error!({code: 401, msg: "该操作没有权限！"})
			end

			@device = Device.find(params[:device_id])
			unless @device && @device.user == @user
				error!({code: 401, msg: "该操作没有权限！"})
			end

			case params[:time_slot]
			when "yesterday"
				@records = @device.yesterday_records
			when "last_week"
				@records = @device.time_slot_records("week")
			when "last_month"
				@records = @device.time_slot_records("month")
			when "all"
				@records = @device.time_slot_records("all")
			else
				@records = @device.today_records
			end

			@records
		end

		desc "Create a record"
		post do
			@device = Device.where(serial_num: params[:serial_num]).first
			@record = Record.new(device_id: @device.id, temperature: params[:temperature], pm25: params[:pm25], formaldehyde: params[:formaldehyde], detect_time: params[:detect_time].to_time)
			if @record.save
				@record
			else
				{code: 406, msg: "数据库存储失败！"}
			end
		end
	end
end
