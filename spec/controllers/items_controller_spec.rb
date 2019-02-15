require 'rails_helper'

describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:categories) { create_list(:category, 2) }
  let(:sizes) { create_list(:size, 2) }
  let(:statuses) { create_list(:status, 2) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'no_image.png')) }
  let(:params) {
    { params: { "images" => { "name" => { "1" => image } }, "item" => { "name"=>"テスト", "description"=>"テスト", "category_id"=>"159", "size_id"=>"1", "brand"=>"", "condition"=>"unused", "shipping_fee"=>"including_postage", "shipping_method"=>"undecided", "shipping_from"=>"hokkaido", "days_before_shipping"=>"in_two_days", "price"=>"9999999"} } }
  }
  let(:params_without_item_name_and_images) {
    { params: { "item" => { "name"=>"", "description"=>"テスト", "category_id"=>"159", "size_id"=>"1", "brand"=>"", "condition"=>"unused", "shipping_fee"=>"including_postage", "shipping_method"=>"undecided", "shipping_from"=>"hokkaido", "days_before_shipping"=>"in_two_days", "price"=>"9999999"} } }
  }

  describe 'GET #index' do
    # @itemsという変数が正しく定義されているか
    it "assigns the requested items to @items" do
      @items = create_list(:item, 4, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
      get :index
      expect(assigns(:items)).to eq(@items)
    end

    # 該当するビューが描画されているか
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do
      @items = create_list(:item, 3, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
      @image = create(:image, name: image, item_id: @items[1][:id])
      @item_image = @items[1].images
      get :show, params: { id: @items[1][:id] }
    end

    # @itemという変数が正しく定義されているか
    it "assigns the requested items to @item" do
      expect(assigns(:item)).to eq(@items[1])
    end

    # @next_itemという変数が正しく定義されているか
    it "assigns the requested items to @next_item" do
      expect(assigns(:next_item)).to eq(@items.last)
    end

    # @prev_itemという変数が正しく定義されているか
    it "assigns the requested items to @prev_item" do
      expect(assigns(:prev_item)).to eq(@items.first)
    end

    # @user_itemsという変数が正しく定義されているか
    it "assigns the requested items to @user_items" do
      expect(assigns(:user_items)).to eq(@items)
    end

    # @category_itemsという変数が正しく定義されているか
    it "assigns the requested items to @category_items" do
      expect(assigns(:category_items)).to eq(@items)
    end

    # @imagesという変数が正しく定義されているか
    it "assigns the requested items to @images" do
      expect(assigns(:images)).to eq(@item_image)
    end

    # 該当するビューが描画されているか
    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context "login" do
      before do
        login_user user
        get :new
      end

      # @itemという変数が正しく定義されているか
      it "assigns the requested items to @item" do
        expect(assigns(:item)).to be_a_new(Item)
      end

      # @sizesという変数が正しく定義されているか
      it "assigns the requested items to @sizes" do
        @sizes = create_list(:size, 2)
        expect(assigns(:sizes)).to eq(@sizes)
      end

      # @categoriesという変数が正しく定義されているか
      it "assigns the requested items to @categories" do
        @categories = create_list(:category, 2, parent_id: 0)
        expect(assigns(:categories)).to eq(@categories)
      end

      # 該当するビューが描画されているか
      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        get :new
        redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    before(:all) do
      Rails.application.load_seed
    end

    context "login" do
      before do
        login_user user
      end

      context "can save" do

        # 保存は成功か
        it 'new item and image' do
          expect{post :create, params}.to change(Image, :count).by(1)
          expect{post :create, params}.to change(Item, :count).by(1)
        end

        # 意図したビューにリダイレクトしているか
        it "redirects to root_path" do
          post :create, params
          redirect_to root_path
        end
      end

      context "can not save" do

        # 保存は失敗か
        it 'new item and image' do
          expect{post :create, params_without_item_name_and_images}.to change(Image, :count).by(0)
          expect{post :create, params_without_item_name_and_images}.to change(Item, :count).by(0)
        end

        # 該当するビューが描画されているか
        it "renders the :new template" do
          post :create, params
          expect(response).to render_template :new
        end
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        redirect_to new_user_session_path
      end
    end
  end
end
