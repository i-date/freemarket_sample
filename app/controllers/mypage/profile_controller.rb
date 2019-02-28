class Mypage::ProfileController < ApplicationController
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
    params.require(:profile).permit(:nickname, :body)
  end
end
