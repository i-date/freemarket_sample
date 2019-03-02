require 'rails_helper'

RSpec.describe Transaction::BuyController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:category) { create(:category) }
  let(:size) { create(:size) }
  let(:statuses) { create_list(:status, 2) }
  let(:item) { create(:item, user_id: users.first.id, category_id: category.id, size_id: size.id, status_id: statuses.first.id) }
  let(:image) { create(:image) }
  let(:credit) { create(:credit, user_id: users.last.id) }
  let(:profile) { create(:profile, user_id: users.last.id) }

  describe 'GET #show' do

    context "ログイン:" do
      before do
        @item = item
        @images = @item.images
        @credit_card = credit
        @profile = profile
        login_user users.last
        get :show, params: { id: @item[:id] }
      end

      it "- @itemという変数が正しく定義" do
        expect(assigns(:item)).to eq(@item)
      end

      it "- @imagesという変数が正しく定義" do
        expect(assigns(:images)).to eq(@images)
      end

      it "- @credit_cardという変数が正しく定義" do
        expect(assigns(:credit_card)).to eq(@credit_card)
      end

      it "- @profileという変数が正しく定義" do
        expect(assigns(:profile)).to eq(@profile)
      end

      it "- showテンプレートが描画" do
        expect(response).to render_template :show
      end
    end

    context "ログアウト:" do

      it "- new_user_session_pathにリダイレクト" do
        get :show, params: { id: item[:id] }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do

    context "ログイン:" do
      before do
        login_user users.last
      end

      context "アクション成功:" do
        before do
          @item = item
          @credit_card = credit
          @profile = profile
          allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.prepare_valid_customer)
          allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
        end

        it '- クレジットカード情報の更新成功' do
          post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
          @credit_card.payjp_token = 'cus_121673955bd7aa144de5a8f6c262'
          expect(assigns(:credit_card)).to eq(@credit_card)
        end

        it '- 取引相手の保存成功' do
          expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(1)
        end

        it '- オーダーの保存成功' do
          expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(1)
        end

        it '- 商品ステータスの更新成功' do
          post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
          @item.status_id = 2
          expect(assigns(:item)).to eq(@item)
        end

        it "- root_pathにリダイレクト" do
          post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
          expect(response).to redirect_to(root_path)
        end
      end

      context "アクション失敗" do
        before do
          @item = item
          @credit_card = credit
          @profile = profile
          login_user users.last
        end

        context "販売中のアイテム以外の場合:" do
          before do
            @item.update(status_id: 2)
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.prepare_valid_customer)
            allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
          end

          it '- クレジットカード情報の更新失敗' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            @credit_card.payjp_token = 'cus_121673955bd7aa144de5a8f6c262'
            expect(assigns(:credit_card)).to eq(@credit_card)
          end

          it '- 取引相手の保存失敗' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(0)
          end

          it '- オーダーの保存失敗' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(0)
          end

          it '- 商品ステータスの更新失敗' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            @item.status_id = 2
            expect(assigns(:item)).to eq(@item)
          end

          it "- transaction_buy_pathにリダイレクト" do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(response).to redirect_to(transaction_buy_path(@item))
          end
        end

        context "payjp顧客登録レスポンスエラーの場合:" do
          before do
            allow(Payjp::Customer).to receive(:create).and_return(Payjp::CardError.new('', {}, 402))
            allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
          end

          it '- クレジットカード情報の更新失敗' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            @credit_card.payjp_token = 'cus_121673955bd7aa144de5a8f6c262'
            expect(assigns(:credit_card)).to eq(@credit_card)
          end

          it '- 取引相手の保存失敗' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(0)
          end

          it '- オーダーの保存失敗' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(0)
          end

          it '- 商品ステータスの更新失敗' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            @item.status_id = 2
            expect(assigns(:item)).to eq(@item)
          end

          it "- transaction_buy_pathにリダイレクト" do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(response).to redirect_to(transaction_buy_path(@item))
          end
        end

        context "payjp支払いレスポンスエラーの場合:" do
          before do
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.prepare_valid_customer)
            allow(Payjp::Charge).to receive(:create).and_raise(Payjp::CardError.new('', {}, 402))
          end

          it '- クレジットカード情報の更新失敗' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            @credit_card.payjp_token = 'cus_121673955bd7aa144de5a8f6c262'
            expect(assigns(:credit_card)).to eq(@credit_card)
          end

          it '- 取引相手の保存失敗' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(0)
          end

          it '- オーダーの保存失敗' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(0)
          end

          it '- 商品ステータスの更新失敗' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            @item.status_id = 2
            expect(assigns(:item)).to eq(@item)
          end

          it "- transaction_buy_pathにリダイレクト" do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(response).to redirect_to(transaction_buy_path(@item))
          end
        end
      end
    end

    context "ログアウト:" do

      it "- new_user_session_pathにリダイレクト" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
