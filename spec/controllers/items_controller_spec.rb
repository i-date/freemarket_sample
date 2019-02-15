require 'rails_helper'

describe ItemsController, type: :controller do
  describe 'GET #index' do
    # @itemsという変数が正しく定義されているか
    it "assigns the requested items to @items" do
      user = create(:user)
      category = create(:category)
      size = create(:size)
      status = create(:status)
      items = create_list(:item, 4, user_id: user.id, category_id: category.id, size_id: size.id, status_id: status.id)
      get :index
      expect(assigns(:items)).to eq items
    end

    # 該当するビューが描画されているか
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end
