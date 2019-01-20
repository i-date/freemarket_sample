class Mypage::IdentificationController < ApplicationController

  def edit
    @profile = Profile.find_by(user_id: current_user.id).present? ? Profile.find_by(user_id: currnet_user.id) : Profile.new
  end

  def update
    # TODO: update処理のコード追加
    @profile = Profile.new(profile_params)
    render :edit
  end

  private

  def profile_params
    params.require(:profile).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :zipcode, :prefecture, :city, :block, :building)
  end
end
