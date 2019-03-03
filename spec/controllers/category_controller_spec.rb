require 'rails_helper'

RSpec.describe CategoryController, type: :controller do
  let(:user) { create(:user) }
  let(:size) { create(:size) }
  let(:status) { create(:status) }

  describe 'GET #show' do
    before do
      @category_top = create(:category, name: 'top')
      @category_middle = create(:category, name: 'middle', parent_id: 1)
      @category_bottom = create(:category, name: 'bottom', parent_id: 2, grandparent_id: 1)
      @item = create(:item, user_id: user.id, category_id: @category_bottom.id, size_id: size.id, status_id: status.id)
    end

    context 'トップカテゴリーを選択したの場合:' do
      before do
        get :show, params: { id: @category_top.id }
      end

      it '- @itemsという変数が正しく定義' do
        expect(assigns(:items)).to match_array(@item)
      end

      # @categoryという変数が正しく定義されているか
      it '- @categoryという変数が正しく定義' do
        expect(assigns(:category)).to eq(@category_top)
      end

      # @category_levelという変数が正しく定義されているか
      it '- @category_levelという変数が正しく定義' do
        expect(assigns(:category_level)).to eq('top')
      end

      # 該当するビューが描画されているか
      it '- showテンプレートが描画' do
        expect(response).to render_template :show
      end
    end

    context 'ミドルカテゴリーを選択した場合:' do
      before do
        get :show, params: { id: @category_middle.id }
      end

      it '- @itemsという変数が正しく定義' do
        expect(assigns(:items)).to match_array(@item)
      end

      # @categoryという変数が正しく定義されているか
      it '- @categoryという変数が正しく定義' do
        expect(assigns(:category)).to eq(@category_middle)
      end

      # @category_levelという変数が正しく定義されているか
      it '- @category_levelという変数が正しく定義' do
        expect(assigns(:category_level)).to eq('middle')
      end

      # 該当するビューが描画されているか
      it '- showテンプレートが描画' do
        expect(response).to render_template :show
      end
    end

    context 'ボトムカテゴリーを選択した場合:' do
      before do
        get :show, params: { id: @category_bottom.id }
      end

      it '- @itemsという変数が正しく定義' do
        expect(assigns(:items)).to match_array(@item)
      end

      # @categoryという変数が正しく定義されているか
      it '- @categoryという変数が正しく定義' do
        expect(assigns(:category)).to eq(@category_bottom)
      end

      # @category_levelという変数が正しく定義されているか
      it '- @category_levelという変数が正しく定義' do
        expect(assigns(:category_level)).to eq('bottom')
      end

      # 該当するビューが描画されているか
      it '- showテンプレートが描画' do
        expect(response).to render_template :show
      end
    end
  end
end
