class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :item_detail, only: [:show]
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
    @next_item = next_item(@item)
    @prev_item = previous_item(@item)
    @user_items = Item.where(user_id: @item.user_id).order("updated_at DESC").limit(3)
    @category_items = Item.where(category_id: @item.category_id).order("updated_at DESC").limit(3)
    @images = @item.images
  end

  private

  def item_detail
    @item = Item.find(params[:id])
  end

  def next_item(item)
    Item.where("id > ?", item.id).order("id ASC").first
  end

  def previous_item(item)
    Item.where("id < ?", item.id).order("id DESC").first
  end
end
