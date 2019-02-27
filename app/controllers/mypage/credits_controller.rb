class Mypage::CreditsController < ApplicationController
  include Common
  before_action :authenticate_user!, only: [:index, :new]

  def index
    # TODO:クレジットカード登録機能実装後、current_user.creditsに変更
    @credit_card = { authorization_code: '1234567890123456', security_code: '999', month: '01', year: '20' }
  end

  def new
    @credit_card = Credit.new
    @months = set_months
    @years = set_years
  end

  def create
  end

  def destroy
  end
end
