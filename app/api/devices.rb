class Devices < Grape::API
  format :json

  resource :devices do
    get do
    end

    desc "Create a device"
    params do
    end
    post do
    end

    desc "Update a device"
    params do
      requires :id, type: String, desc: "Device id"

    end
    put ':id' do
    end

    desc "Delete a device"
    params do
      requires :id, type: String, desc: "Device id"
    end
    delete ':id' do
    end
  end
end
