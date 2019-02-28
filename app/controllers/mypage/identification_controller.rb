class Mypage::IdentificationController < ApplicationController
  before_action :authenticate_user!

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      redirect_to mypage_top_path
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :zipcode, :prefecture, :city, :block, :building)
  end
end
