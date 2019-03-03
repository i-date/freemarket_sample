class Transaction::OrderStatusController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  layout 'devise'

  def show
    @item = Item.find(params[:id])
    @images = @item.images
    @profile = current_user.profile
    @credit_card = Credit.find_by(user_id: current_user.id)
  end
end
