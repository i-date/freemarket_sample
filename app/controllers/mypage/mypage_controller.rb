class Mypage::MypageController < ApplicationController
  include Common
  before_action :move_to_root

  def index
    @user = User.find(current_user.id)
    # TODO:仮のデータ修正
    @notice = [{id: 1, text: 'お知らせ：お得なキャンペーン始まりました！詳細はこちら'}]
    @todo = []
    @trading_items = []
    @purchased_items = []
  end
end
