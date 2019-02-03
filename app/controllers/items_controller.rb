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
end
