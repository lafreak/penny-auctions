class ManageController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    authorize @users
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def save
    @user = User.find(params[:id])
    authorize @user

    if @user.update(manage_params)
      flash[:success] = "User has been saved."
      redirect_to manage_index_path
    else
      render 'edit'
    end
  end

  def delete
    @user = User.find(params[:id])
    authorize @user
    @user.destroy

    flash[:success] = "User has been removed."
    redirect_to manage_index_path
  end

  def block
    @user = User.find(params[:id])
    authorize @user

    flash[:success] = "Blockade has been changed."
    @user.update(blocked: !@user.blocked)

    redirect_to manage_index_path
  end

  def role
    @user = User.find(params[:id])
    authorize @user

    flash[:success] = "Role has been assigned"
    @user.update(role: params[:role])

    redirect_to manage_index_path
  end

  private
  
  def manage_params
    params.require(:user).permit(:name, :address, :email, :balance)
  end
end
