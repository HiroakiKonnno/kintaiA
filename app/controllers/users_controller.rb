class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
   @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to root_url
    else
      render :new
    end
  end
  
   private

    def user_params
      params.require(:user).permit(:name, :email, :belonging, :password, :password_confirmation)
    end

end
