class Mypage::MypageController < ApplicationController
  before_action :move_to_root

  def index
    @user = User.find(current_user.id)
    # TODO:仮のデータ修正
    @notice = [{id: 1, text: 'お知らせ：お得なキャンペーン始まりました！詳細はこちら'}]
    @todo = []
    @trading_items = []
    @purchased_items = []
  end

  private

  def move_to_root
    redirect_to root_path unless user_signed_in?
  end
end
