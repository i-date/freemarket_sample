class ItemsController < ApplicationController

  def index
    @categories = Category.eager_load(children: :children).where(parent_id: 0)
  end
end
