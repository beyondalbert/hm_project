require 'records'
class Base < Grape::API
	mount Records
	mount Devices
	mount Users
end
