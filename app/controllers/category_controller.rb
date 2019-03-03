class CategoryController < ApplicationController

  def index
  end

  def show
    @category = Category.find(params[:id])
    select_category_level(@category)
    @items = Item.get_category_items(@category_id_range).includes(:images)
  end

  private

  def select_category_level(category)
    # トップカテゴリー選択
    if category.parent_id == 0
      @category_level = 'top'
      categories = category.grandchildren
      @category_id_range = get_id_range(categories)
    # ミドルカテゴリー選択
    elsif category.parent_id != 0 && category.grandparent_id == 0
      @category_level = 'middle'
      categories = category.children
      @category_id_range = get_id_range(categories)
    # ボトムカテゴリー選択
    else
      @category_level = 'bottom'
      @category_id_range = category.id
    end
  end

  def get_id_range(categories)
    start_id = categories.first.id
    end_id = categories.last.id
    Range.new(categories.first.id, categories.last.id)
  end
end
