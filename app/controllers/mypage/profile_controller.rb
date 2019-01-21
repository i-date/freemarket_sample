class Mypage::ProfileController < ApplicationController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    @profile.nickname = profile_params[:nickname]
    @profile.body = profile_params[:body]
    # TODO: レコードの更新用コードを記述
    render :edit
  end

  private

  def profile_params
    params.require(:profile).permit(:nickname, :body)
  end
end
