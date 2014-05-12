class Records < Grape::API
  format :json
  resource :records do
    get :hello do
      {hello: "world"}
    end

		desc "get device's data"
    get do
      Record.all
    end

    desc "Create a record"
    post do
      @device = Device.where(serial_num: params[:serial_num]).first
      Record.create!(device_id: @device.id, temperature: params[:temperature], pm25: params[:pm25], formaldehyde: params[:formaldehyde], detect_time: params[:detect_time].to_time)

    end

    desc "Return a record"
    params do
      requires :id, type: Integer, desc: "Record id"
    end
    route_param :id do
      get do
        Record.find(params[:id])
      end
    end
  end
end
