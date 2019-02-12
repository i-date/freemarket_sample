class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :set_item, only: [:show]
  layout 'devise', only: [:new]

  def index
    @items = Item.sort_update_desc.limit(4)
  end

  def new
    @item = Item.new
    @item.images.build
    @sizes = Size.all
  end

  def create
  end

  def show
    @next_item = Item.get_next_item(@item).first
    @prev_item = Item.get_previous_item(@item).first
    @user_items = Item.get_user_items(@item).limit(3)
    @category_items = Item.get_category_items(@item).limit(3)
    @images = @item.images
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
