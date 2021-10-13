class AttendancesController < ApplicationController
  include AttendancesHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :correct_user, only: :update_one_month
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end


  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        @attendance = Attendance.find(id)
        @attendance.update_attributes!(item.merge(day_status: "申請中"))
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を申請しました。"
    redirect_to user_url(date: params[:date])
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def change_month
    @user = User.find(params[:id])
    @attendances = Attendance.where(day_status: '申請中', day_sperior: @user.belonging).group_by(&:user_id)
  end

  def change_approval
    @user = User.find(params[:id])
    change_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:day_modify] == "true"
        @attendance.update_attributes(item)
        flash[:success] = "勤怠情報を更新しました。"
        redirect_to user_url(date: params[:date])
      else
        flash[:danger] = "更新できなかった勤怠情報があります"
        redirect_to user_url(date: params[:date])
      end
    end
  end


  def monthly_confirmation
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day)
  end


  def overtime_info
    @user = User.find(params[:id])
    @attendance = @user.attendances.find_by(worked_on: params[:date])
  end

  def overtime_confirmation
    @attendance = Attendance.find(params[:id])
    if overtime_confirmation_params[:overwork_time].present?
      @attendance.update_attributes(overtime_confirmation_params)
      flash[:success] = "勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date])
    else
      flash[:danger] = "終了時間が未入力です"
      redirect_to user_url(date: params[:date])
    end
  end

  def overtime_view
    @user = User.find(params[:id])
    @attendances = Attendance.where(overwork_status: '申請中', overwork_sperior: @user.belonging).group_by(&:user_id)
  end

  def overtime_approval
    @user = User.find(params[:id])
    @attendances = Attendance.where(overwork_status: '申請中', overwork_sperior: @user.belonging)
    overtime_approval_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:overtime_modify] == "true"
        @attendance.update(item)
        flash[:success] = "更新しました"
      else
        flash[:danger] = "更新できなかったものあります"
      end
    end
    redirect_to @user
  end

 

private
  # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:before_changed_started_at, :before_changed_finished_at, :note, :day_sperior, :day_tomorrow])[:attendances]
  end

  def change_params
    params.require(:user).permit(attendances: [:before_changed_started_at, :before_changed_finished_at, :day_status, :day_modify])[:attendances]
  end

  def overtime_confirmation_params
    params.require(:attendance).permit(:overwork_time, :overwork_tomorrow, :overwork_note,:overwork_sperior).merge(overwork_status: "申請中")
  end

  def overtime_approval_params
    params.require(:user).permit(attendances: [:overwork_modify, :overwork_status])[:attendances]
  end


  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
  end
end