class ItemsController < ApplicationController

  def index
    @items = Item.order("updated_at DESC").limit(4)
  end
end
