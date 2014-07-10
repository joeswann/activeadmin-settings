class ActiveadminSettings::UsersController < ApplicationController
  before_filter :authenticate_admin_user!

  def update
    @object = User.find(params[:id])
    if @object.update_attributes(permitted_params[:admin_user])
      render :text => "ok"
    else
      render :text => @object.errors.to_json, :status => :unprocessable_entity
    end
  end

  def create
    @object = User.new(permitted_params[:admin_user])
    if @object.save
      render :partial => "admin/settings/admin", :locals => {:admin => @object}, :layout => false
    else
      render :text => @object.errors.to_json, :status => :unprocessable_entity
    end
  end

  def destroy
    @object = User.find(params[:id])
    @object.destroy
    redirect_to "/admin/settings#admins"
  end

  # Define the permitted params in case the app is using Strong Parameters
  def permitted_params
    if Rails::VERSION::MAJOR == 3 && !defined? StrongParameters
      params
    else
      params.permit admin_user: [:email, :password, :password_confirmation]
    end
  end 
end