class ManageController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def save
    @user = User.find(params[:id])
    @user.update(manage_params)

    redirect_to manage_index_path
  end

  def delete
    @user = User.find(params[:id])
    @user.destroy

    redirect_to manage_index_path
  end

  private
  
  def manage_params
    params.require(:user).permit(:name, :surname, :email, :balance)
  end
end
