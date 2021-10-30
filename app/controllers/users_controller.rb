class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:employee, :index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:edit,:show]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :index]
  before_action :set_one_month, only: [:show]
  
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @month_count = Attendance.where(month_status: '申請中', month_sperior: @user.belonging).count
    @overtime_count = Attendance.where(overwork_status: '申請中', overwork_sperior: @user.belonging).count
    @day_count = Attendance.where(day_status: '申請中', day_sperior: @user.belonging).count
    @approval = Attendance.find_by(month_status: '承認', worked_on: @first_day, user_id: @user.id)
    @deny = Attendance.find_by(month_status: '否認', worked_on: @first_day, user_id: @user.id)
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
    @employees = @user.attendances.where.not(started_at: nil).where(finished_at: nil).where('worked_on Like?', "%#{Time.now.strftime("%m-%d")}%")
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
    else
      flash[:danger] = "更新は失敗しました." 
    end
    redirect_to users_url
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

  def update_confirmation
    @user = User.find(params[:id])
    @attendance = @user.attendances.where(worked_on: params[:worked_on])
    @attendance.update(confirmation_info_params)
      flash[:success] = "送信は成功しました。"
      redirect_to @user
  end

  def monthly_confirmation_info
    @user = User.find(params[:id])
    @attendance = @user.attendances.where(worked_on: params[:worked_on])
    @attendances = Attendance.where(month_status: '申請中', month_sperior: @user.belonging).group_by(&:user_id)
  end

  def approve_monthly_info
    @approver = User.find(params[:id])
    @attendances = Attendance.where(month_status: '申請中', month_sperior: @approver.belonging)
      approve_monthly_params.each do |id, item|
        @attendance = Attendance.find(id)
        if item[:month_modify] == "true"
          @attendance.update(item)
          flash[:success] = "更新しました"
        else
          flash[:danger] = "更新できなかったものあります"
        end
      end
    redirect_to @approver
  end

  
     private
   
   def user_params
      params.permit(:name, :email, :belonging, :employee_number, :uid, :password, :password_confirmation, :basic_time, :designated_work_start_time, :designated_work_end_time)
   end
   
   def basic_info_params
      params.require(:user).permit(:basic_time)
   end

  
   def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
   end

   def confirmation_info_params
    params.permit(:month_sperior).merge(month_status: "申請中", worked_on: params[:worked_on])
   end

   def approve_monthly_params
    params.require(:user).permit(attendances: [:month_status, :month_modify])[:attendances]
   end

end
   
