class StoresController < ApplicationController
  # adminユーザーのみ
  before_action :logged_in_admin, only: %i[show new edit create update]

  def show
    @store = current_user.store
  end

  def new
    # 店舗情報が存在しない場合のみ作成できるようにする
    if current_user.store.nil?
      @store = current_user.build_store
    else
      redirect_to root_url
    end
  end

  def edit
    @store = current_user.store
  end

  def create
    # 1対1の時はbuild_というメソッドを使わなければいけない
    @store = current_user.build_store(store_params)

    if @store.save
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    @store = current_user.store
    if @store.update_attributes(store_params)
      # flash[:success] = "Profile updated"
      redirect_to stores_show_url
    else
      render :edit
    end
  end

  private

    def logged_in_admin
      unless current_user.admin?
        flash[:danger] = '管理者のみアクセスできるページです。'
        redirect_to root_url
      end
    end

    def store_params
      params.require(:store).permit(:emp_per_day_number, :business_start_time, :business_end_time, :regular_holiday)
    end

end
