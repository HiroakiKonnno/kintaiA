class BranchController < ApplicationController
  def index
    @branches = if params[:search]
        Branch.paginate(page: params[:page]).where('name LIKE ?',"%#{params[:search]}%")
      else
        Branch.paginate(page: params[:page])
      end
  end

  def create
    @branch = Branch.new(branch_params)
    if @branch.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to branch_index_url
    else
      render :index
    end
  end
       
    def edit
    end
       
    def update
     @branch = Branch.find(params[:id])
     if @branch.update_attributes(branch_params)
         flash[:success] = "拠点情報を更新しました。"
         redirect_to branch_index_url
     else
        render :index
     end
    end
       
    def destroy
      @branch = Branch.find(params[:id])
      @branch.destroy
        flash[:success] = "#{@branch.name}のデータを削除しました。"
        redirect_to branch_index_url
    end

    def branch_params
      params.permit(:name, :number, :kind)
    end
   
end
