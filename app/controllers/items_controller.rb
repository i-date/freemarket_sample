class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  layout 'devise', only: [:new]

  def index
    @items = Item.order("updated_at DESC").limit(4)
  end

  def new
    @item = Item.new
    @item.images.build
    @sizes = Size.all
  end

  def create
  end

  def show
    @item = Item.find(params[:id])
    @next_item = Item.find(params[:id].to_i + 1) if params[:id].to_i != Item.last.id
    @prev_item = Item.find(params[:id].to_i - 1) if params[:id].to_i - 1 != 0
    @user_items = Item.where(user_id: @item.user_id).order("updated_at DESC").limit(3)
    @category_items = Item.where(category_id: @item.category_id).order("updated_at DESC").limit(3)
    @images = @item.images
  end
end
