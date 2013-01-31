module Adf
  class PasswordResetsController < ApplicationController
    def edit
      @user = User.find_by_password_reset_token!(params[:id])
    end
    
    def update
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        respond_with @user, :location => root_url
      elsif @user.update_attributes(params[:user])
        respond_with @user, :location => root_url
      else
        render :edit
      end
    end
    
  end
end