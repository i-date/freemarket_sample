class Mypage::CardController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new]

  def index
    # TODO:クレジットカード登録機能実装後、current_user.creditsに変更
    @credit_card = {}
  end

  def new
    @credit_card = Credit.new
    @months = Credit.get_months
    @years = Credit.get_years
  end

  def create
  end

  def destroy
  end
end
