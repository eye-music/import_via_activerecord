class UsersController < ApplicationController
	def new
  		@user = User.new
  	end

	def create
		return redirect_to :back if params["user"]["file"].nil?
  		@success_count, @failed_count = User.import_file(params["user"]["file"])
  		@user = User.new
  		render "new", :locals => {:success_count => @success_count, :failed_count => @failed_count, :user=> @user}
  	end
end
