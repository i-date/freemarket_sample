class ItemsController < ApplicationController

  def index
    @items = Item.order("updated_at DESC").limit(4)
    @categories = Category.eager_load(children: :children).where(parent_id: 0)
  end
end
