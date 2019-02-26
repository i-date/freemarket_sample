class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  layout 'devise', only: [:new, :create, :edit, :update]

  def index
    @items = Item.sort_update_desc.limit(4)
    @none_breadcrumbs_flag = true;
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

  def search
    # ransack用変数設定
    initilize_ransack_variable
    initilize_ransack_symbol
    # クエリー設定
    q = set_query_params
    # 検索結果取得
    if q.length != 1
      @query = Item.ransack(q)
      @search_result = @query.result.includes(:images)
    end
    @new_items = Item.sort_update_desc.limit(24).includes(:images)
    # 再検索のため、クエリー初期化
    @query = Item.ransack({})
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

  def query_params
    params.require(:q).permit(
      :name_or_description_or_brand_or_category_name_or_category_parent_name_or_category_grandparent_name_cont,
      :sorts,
      :size_id_eq,
      :price_gteq,
      :price_lteq,
      :brand_cont_any,
      :category_grandparent_id_eq,
      :category_parent_id_eq,
      category_id_eq_any: [],
      condition_eq_any: [],
      shipping_fee_eq_any: [],
      status_id_eq_any: [],
    ) if params[:q].present?
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

  def initilize_ransack_variable
    # 詳細検索用インスタンス変数
    @sort_list = Item.sort_select_list
    @size_list = Size.all
    @price_list = Item.price_select_list
    @condition_list = Item.condition_check_list
    @fee_list = Item.fee_check_list
    @status_list = Item.status_check_list
  end

  def initilize_ransack_symbol
    # 詳細検索対象カラム指定、このメソッド内のみでransackに必要なシンボルを操作決定
    @keyword_sym = :name_or_description_or_brand_or_category_name_or_category_parent_name_or_category_grandparent_name_cont
    @sort_sym = :sorts
    @category_sym = :category_id_eq_any
    @category_parent_sym = :category_parent_id_eq
    @category_grandparent_sym = :category_grandparent_id_eq
    @brand_sym = :brand_cont_any
    @size_sym = :size_id_eq
    @price_gteq_sym = :price_gteq
    @price_lteq_sym = :price_lteq
    @condition_sym = :condition_eq_any
    @fee_sym = :shipping_fee_eq_any
    @status_sym = :status_id_eq_any
  end

  def set_query_params
    # ransack用変数設定
    initilize_ransack_symbol
    @q = {}

    # 検索キーワード
    @query_keyword = query_params[@keyword_sym].present? ? query_params[@keyword_sym] : '検索結果'
    @keywords = query_params[@keyword_sym]
    # 以下複数キーワード（AND）検索用
    if @keywords.present?
      @q[:groupings] = []
      @keywords.split(/[\s|　]+/).each_with_index do |word, i|
        @q[:groupings][i] = { @keyword_sym => word }
      end
    end
    # topカテゴリー
    @q[@category_grandparent_sym] = query_params[@category_grandparent_sym] if query_params[@category_grandparent_sym].present?
    # middleカテゴリー
    @q[@category_parent_sym] = query_params[@category_parent_sym] if query_params[@category_parent_sym].present?
    # bottomカテゴリー
    @q[@category_sym] = query_params[@category_sym] if query_params[@category_sym].present?
    # ブランド
    @q[@brand_sym] = query_params[@brand_sym].split(/[\s|　]+/) if query_params[@brand_sym].present?
    # サイズ
    @q[@size_sym] = query_params[@size_sym] if query_params[@size_sym].present?
    # 最低価格
    @q[@price_gteq_sym] = query_params[@price_gteq_sym] if query_params[@price_gteq_sym].present?
    # 最高価格
    @q[@price_lteq_sym] = query_params[@price_lteq_sym] if query_params[@price_lteq_sym].present?
    # 商品状態
    @q[@condition_sym] = query_params[@condition_sym] if query_params[@condition_sym].present?
    # 配送料負担
    @q[@fee_sym] = query_params[@fee_sym] if query_params[@fee_sym].present?
    # 販売状況
    @q[@status_sym] = query_params[@status_sym].join(',').split(',') if query_params[@status_sym].present?

    # ソートを選択した場合
    if query_params[@sort_sym].present?
      @q = session[:search_q]
      @q[@sort_sym] = query_params[@sort_sym]
    end
    # デフォルトソート設定
    @q[@sort_sym] = 'updated_at DESC' if @q[@sort_sym].blank?

    # ソート用にセッションに保存
    session[:search_q] = @q

    return @q
  end
end

