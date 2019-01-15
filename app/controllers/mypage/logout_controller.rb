class Mypage::LogoutController < ApplicationController
  include Common
  before_action :move_to_root

  def index
  end
end
