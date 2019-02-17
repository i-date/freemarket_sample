require 'rails_helper'

describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:categories) { create_list(:category, 2) }
  let(:sizes) { create_list(:size, 2) }
  let(:statuses) { create_list(:status, 2) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'no_image.png')) }

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
    it "assigns the requested item to @item" do
      expect(assigns(:item)).to eq(@items[1])
    end

    # @next_itemという変数が正しく定義されているか
    it "assigns the requested next_item to @next_item" do
      expect(assigns(:next_item)).to eq(@items.last)
    end

    # @prev_itemという変数が正しく定義されているか
    it "assigns the requested prev_item to @prev_item" do
      expect(assigns(:prev_item)).to eq(@items.first)
    end

    # @user_itemsという変数が正しく定義されているか
    it "assigns the requested user_items to @user_items" do
      expect(assigns(:user_items)).to eq(@items)
    end

    # @category_itemsという変数が正しく定義されているか
    it "assigns the requested category_items to @category_items" do
      expect(assigns(:category_items)).to eq(@items)
    end

    # @imagesという変数が正しく定義されているか
    it "assigns the requested images to @images" do
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
      it "assigns the requested item to @item" do
        expect(assigns(:item)).to be_a_new(Item)
      end

      # @sizesという変数が正しく定義されているか
      it "assigns the requested sizes to @sizes" do
        @sizes = create_list(:size, 2)
        expect(assigns(:sizes)).to eq(@sizes)
      end

      # @categoriesという変数が正しく定義されているか
      it "assigns the requested categories to @categories" do
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
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do

    context "login" do
      before do
        login_user user
      end

      context "can save" do
        before do
          @item = build(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
          @item_params = @item.attributes.tap do |ip|
            ip["category_id"] = ip["category_id"].to_s
            ip["size_id"] = ip["size_id"].to_s
          end
        end

        # 商品の保存は成功か
        it 'new item' do
          expect{post :create, params: {"images" => { "name" => { "1" => image } }, item: @item_params}}.to change(Item, :count).by(1)
        end

        # イメージの保存は成功か
        it 'new image' do
          expect{post :create, params: {"images" => { "name" => { "1" => image } }, item: @item_params}}.to change(Image, :count).by(1)
        end

        # 意図したビューにリダイレクトしているか
        it "redirects to root_path" do
          post :create, params: {"images" => { "name" => { "1" => image } }, item: @item_params}
          expect(response).to redirect_to(root_path)
        end
      end

      context "can not save" do
        before do
          @item = build(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
          @item_params = @item.attributes.tap do |ip|
            ip["category_id"] = ip["category_id"].to_s
            ip["size_id"] = ''
          end
        end

        # 商品の保存は失敗か
        it 'new item' do
          expect{post :create, params: {"images" => { "name" => { "1" => '' } }, item: @item_params}}.to change(Item, :count).by(0)
        end

        # イメージの保存は失敗か
        it 'new image' do
          expect{post :create, params: {"images" => { "name" => { "1" => '' } }, item: @item_params}}.to change(Image, :count).by(0)
        end

        # 該当するビューが描画されているか
        it "renders the :new template" do
          post :create, params: {"images" => { "name" => { "1" => '' } }, item: @item_params}
          expect(response).to render_template :new
        end
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        @item = build(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
        @item_params = @item.attributes.tap do |ip|
          ip["category_id"] = ip["category_id"].to_s
          ip["size_id"] = ip["size_id"].to_s
        end
        post :create, params: {"images" => { "name" => { "1" => image } }, item: @item_params}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context "login" do
      before do
        login_user user
        @item = create(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
        get :edit, params: { id: @item.id }
      end

      # @itemという変数が正しく定義されているか
      it "assigns the requested item to @item" do
        expect(assigns(:item)).to eq(@item)
      end

      # @sizesという変数が正しく定義されているか
      it "assigns the requested sizes to @sizes" do
        expect(assigns(:sizes)).to eq(sizes)
      end

      # @categoriesという変数が正しく定義されているか
      it "assigns the requested categories to @categories" do
        expect(assigns(:categories)).to eq(categories)
      end

      # 該当するビューが描画されているか
      it "renders the :edit template" do
        expect(response).to render_template :edit
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        @item = create(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
        get :edit, params: {id: @item.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context "login" do
      before do
        @user1 = create(:user)
        login_user @user1
      end

      context "current user is seller exhibitting the item" do

        context "can update" do
          before do
            @item = create(:item, user_id: @user1.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
            @item_params = @item.attributes.tap do |ip|
              ip["category_id"] = ip["category_id"].to_s
              ip["size_id"] = ip["size_id"].to_s
            end
          end

          # 更新は成功か
          it 'item' do
            patch :update, params: {id: @item.id, "images" => { "name" => { "1" => image } }, item: @item_params}
            expect(assigns(:item)).to eq(@item)
          end

          # プロパティは更新されているか
          it "changes @item's attributes" do
            @item_params["name"] = "アップデート"
            patch :update, params: {id: @item.id, "images" => { "name" => { "1" => image } }, item: @item_params}
            @item.reload
            expect(@item.name).to eq("アップデート")
          end

          # 意図したビューにリダイレクトしているか
          it "redirects to item_path" do
            patch :update, params: {id: @item.id, "images" => { "name" => { "1" => image } }, item: @item_params}
            expect(response).to redirect_to(item_path)
          end
        end

        context "can not update" do
          before do
            @item = create(:item, user_id: @user1.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
            @item_params = @item.attributes.tap do |ip|
              ip["category_id"] = ip["category_id"].to_s
              ip["size_id"] = ''
            end
          end

          # 更新は失敗か
          it 'item' do
            @before_name = @item_params["name"]
            @item_params["name"] = "アップデート"
            patch :update, params: {id: @item.id, "images" => { "name" => { "1" => image } }, item: @item_params}
            @item.reload
            expect(@item.name).to eq(@before_name)
          end

          # 該当するビューが描画されているか
          it "renders the :edit template" do
            patch :update, params: {id: @item.id, item: @item_params}
            expect(response).to render_template :edit
          end
        end
      end

      context "current user is not seller exhibitting the item" do
        # 意図したビューにリダイレクトしているか
        it "redirects to root_path" do
          @item = create(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
          @item_params = @item.attributes.tap do |ip|
            ip["category_id"] = ip["category_id"].to_s
            ip["size_id"] = ip["size_id"].to_s
          end
          patch :update, params: {id: @item.id, "images" => { "name" => { "1" => image } }, item: @item_params}
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        @item = create(:item, user_id: user.id, category_id: categories.first.id, size_id: sizes.first.id, status_id: statuses.first.id)
        @item_params = @item.attributes.tap do |ip|
          ip["category_id"] = ip["category_id"].to_s
          ip["size_id"] = ip["size_id"].to_s
        end
        patch :update, params: {id: @item.id, "images" => { "name" => { "1" => image } }, item: @item_params}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
