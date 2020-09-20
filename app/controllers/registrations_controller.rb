=begin
    Original Author: Kapil Jani
    Development Group: SOI
    Description: This controller contains common methods for signing up user, update user profile
=end
class RegistrationsController < ApplicationController

	def new
		@user = User.new
		@url = user_registration_path
	end

    def create
    	@user = User.new
    	@user.email = params[:user][:email]
    	@user.password = params[:user][:password]
    	if @user.save 
    		#token = JWT.encode({user_id: @user.id, exp: (Time.now + 2.weeks).to_i}, Rails.env.eql?('staging') ? Rails.application.credentials[:secret_key_base] : Rails.application.credentials[:secret_key_base], 'HS256')
    		#@user.update_attributes(authentication_token: @token)
    		session[:user_id] = @user.id
    		redirect_to dashboard_index_path
    	else
    		render 'new'
    	end
    end

    private

    def user_params
        params.permit(:email, :password, :password_confirmation)
    end
end
