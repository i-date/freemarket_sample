class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  layout 'devise', only: [:new, :create, :edit, :update]

  def index
    @items = Item.sort_update_desc.limit(4)
  end

  def new
    @item = Item.new
    @image = Image.new
    @sizes = Size.all
  end

  def create
    @item = Item.new(to_int_category_id_and_size_id)
    if @item.save & save_images(@item, image_params)
      redirect_to root_path, notice: '出品しました。'
    else
      initialize_item_size_image
      render :new
    end
  end

  def show
    @next_item = Item.get_next_item(@item).first
    @prev_item = Item.get_previous_item(@item).first
    @user_items = Item.get_user_items(@item).limit(3)
    @category_items = Item.get_category_items(@item).limit(3)
    @images = @item.images
  end

  def edit
    initialize_item_size_image
  end

  def update
    redirect_to root_path and return unless current_user.id == @item.user_id
    if @item.update(to_int_category_id_and_size_id)
      @item.images.each do |image|
        image.destroy
      end
      if save_images(@item, image_params)
        redirect_to item_path(@item)
      else
        @item = replace_item_value(@item, to_int_category_id_and_size_id)
        initialize_item_size_image
        render :edit
      end
    else
      @item = replace_item_value(@item, to_int_category_id_and_size_id)
      initialize_item_size_image
      render :edit
    end
  end

  def destroy
    @item.destroy if @item.user_id === current_user.id
    redirect_to root_path
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :price,
      :description,
      :condition,
      :shipping_fee,
      :shipping_from,
      :days_before_shipping,
      :shipping_method,
      :brand,
      :category_id,
      :size_id
    ).merge(user_id: current_user.id, status_id: 1)
  end

  def image_params
    params.require(:images).require(:name).permit(params[:images][:name].keys) if params[:images].present?
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def initialize_item_size_image
    # 無効なvalue値を削除：category_id、size_id
    @item[:category_id] = ''
    @item[:size_id] = ''
    @item[:price] = ''
    @sizes = Size.all
    @image = Image.new
  end

  def to_int_category_id_and_size_id
    item_params.tap do |ip|
      ip[:category_id] = ip[:category_id].to_i
      ip[:size_id] = ip[:size_id].to_i
    end
  end

  def save_images(item, images)
    if images.present?
      return false if item.id.blank?
      images.values.each do |name|
        @image = item.images.create(name: name)
      end
    else
      @image_error = "画像がありません"
      return false
    end
  end

  def replace_item_value(item, hash)
    hash.each do |key, val|
      item[key.to_sym] = val
    end
    return item
  end
end

