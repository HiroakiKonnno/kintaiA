class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:employee, :index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:update]
  before_action :admin_or_correct_user, only: [:edit,:show]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :index]
  before_action :set_one_month, only: :show
  
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def index
    @users = if params[:search]
    User.paginate(page: params[:page]).where('name LIKE ?',"%#{params[:search]}%")
  else
    User.paginate(page: params[:page])
  end
  
  end

  def employee
    @user = User.find(params[:id])
    @users = if params[:search]
      User.paginate(page: params[:page]).where('name LIKE ?',"%#{params[:search]}%")
  else
      User.paginate(page: params[:page])
  end
    @employees = @user.attendances.where.not(started_at: nil).where(finished_at: nil)
  end

  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end
  
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
  
  def edit
  end
  
  def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:success] = "ユーザー情報を更新しました。"
    redirect_to users_path
  else
    render :edit
  end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end

  def update_basic_info
  @user = User.find(params[:id])
  if @user.update_attributes(basic_info_params)
    flash[:success] = "基本情報を更新しました。"
  else
    flash[:danger] = "更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
  end
  redirect_to @user
  end
  
   private
   
   def user_params
      params.require(:user).permit(:name, :email, :belonging, :employee_number, :uid, :password, :password_confirmation, :basic_time, :designated_work_start_time, :designated_work_end_time)
   end
   
   def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
   end

   def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
   end

end
   
