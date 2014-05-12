require 'digest/md5'
class Users < Grape::API
	format :json

	resource :users do
		desc "user login"
		post :login do
    	user = User.authenticate(params[:email], params[:password])
			if user
				token = Digest::MD5.hexdigest(user.id.to_s + Time.now.to_s)
				@api_token = ApiToken.new(user_id: user.id, api_token: token, expire_time: 7.days.from_now)
				if @api_token.save
					{user: user, api_token: @api_token}
				else
					{code: 406, msg: "数据库存储失败！"}
				end

			else
				{code: 401, msg: "用户登录失败！"}
			end
		end

		desc "user logout"
		delete :logout do
			@api_token = ApiToken.find_by_api_token(params[:api_token])
			if @api_token
				if @api_token.expire_time > Time.now
					@api_token.destroy
					{code: 200, msg: "用户退出成功！"}
				else
					{code: 401, msg: "token过期！"}
				end
			else
				{code: 401, msg: "该操作没有权限！"}
			end
		end

		desc "user register"
		post :register do
			@user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
			if @user.save
				@api_token = ApiToken.new(user_id: @user.id, api_token: Digest::MD5.hexdigest(@user.id.to_s + Time.now.to_s), expire_time: 7.days.from_now)
				if @api_token.save
					{user: @user, api_token: @api_token}
				end
			else
				{code: 406, msg: "数据库存储失败！"}
			end
		end
	end
end
