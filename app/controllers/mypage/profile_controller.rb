class Mypage::ProfileController < ApplicationController

  def edit
    @user_detail = UserDetail.new
    @user = User.find(current_user.id)
    @profile = Profile.find_by(user_id: current_user.id).present? ? Profile.find_by(user_id: currnet_user.id) : Profile.new
  end

  def update
    # TODO: レコードの更新用コードを記述
    render :edit
  end

  private

  def user_detail_params
    params.require(:user_detail).permit(:nickname, :body, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :phone_number, :zipcode, :prefecture, :city, :block, :building)
  end
end
