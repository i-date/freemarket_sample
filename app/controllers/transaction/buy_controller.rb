class Transaction::BuyController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  before_action :set_variable, only: [:show, :create]
  layout 'devise'

  def create
    ActiveRecord::Base.transaction do
      if @item.status_id == 1
        if @credit_card.payjp_token.present?
        create_purchase_history_and_update_item_status(@item, @credit_card)
        else
          customer_token = MyPayjp.create_customer(payjp_params[:payjp_token])
          @credit_card.update(payjp_token: customer_token[:id]) if @credit_card.user_id == current_user.id
          create_purchase_history_and_update_item_status(@item, @credit_card)
        end
      else
        raise
      end
    end
    redirect_to root_path

    # 購入処理に失敗した場合
    rescue => e
      redirect_to transaction_buy_path(@item), alert: '商品の購入に失敗しました'
  end

  def show
  end

  private

  def payjp_params
    params.permit(:id, :payjp_token)
  end

  def set_variable
    @item = Item.find(params[:id])
    @images = @item.images
    @profile = current_user.profile
    @credit_card = Credit.find_by(user_id: current_user.id)
  end

  def create_purchase_history_and_update_item_status(item, card)
    partner = TradingPartner.where(seller_id: item.user_id, buyer_id: current_user.id).first_or_create
    Order.create(item_id: payjp_params[:id], trading_partner_id: partner.id)
    item.update(status_id: 2)
    MyPayjp.create_charge_by_customer(card.payjp_token, item.price.to_i)
  end
end
