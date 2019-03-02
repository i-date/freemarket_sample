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

    context "login" do
      before do
        @item = item
        @images = @item.images
        @credit_card = credit
        @profile = profile
        login_user users.last
        get :show, params: { id: @item[:id] }
      end

      # @itemという変数が正しく定義されているか
      it "assigns the requested item to @item" do
        expect(assigns(:item)).to eq(@item)
      end

      # @imagesという変数が正しく定義されているか
      it "assigns the requested images to @images" do
        expect(assigns(:images)).to eq(@images)
      end

      # @credit_cardという変数が正しく定義されているか
      it "assigns the requested credit_card to @credit_card" do
        expect(assigns(:credit_card)).to eq(@credit_card)
      end

      # @profileという変数が正しく定義されているか
      it "assigns the requested profile to @profile" do
        expect(assigns(:profile)).to eq(@profile)
      end

      # 該当するビューが描画されているか
      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        get :show, params: { id: item[:id] }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do

    context "login" do
      before do
        login_user users.last
      end

      context "can save" do
        before do
          @item = item
          @credit_card = credit
          @profile = profile
          allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.prepare_valid_customer)
          allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
        end

        # クレジットカード情報の更新は成功か
        it 'payjp_token of credit is successfully updated' do
          post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
          @credit_card.payjp_token = 'cus_121673955bd7aa144de5a8f6c262'
          expect(assigns(:credit_card)).to eq(@credit_card)
        end

        # 取引相手の保存は成功か
        it 'trading_partner' do
          expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(1)
        end

        # オーダーの保存は成功か
        it 'order' do
          expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(1)
        end

        # 商品ステータスの更新は成功か
        it 'item' do
          post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
          @item.status_id = 2
          expect(assigns(:item)).to eq(@item)
        end

        # 意図したビューにリダイレクトしているか
        it "redirects to root_path" do
          post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
          expect(response).to redirect_to(root_path)
        end
      end

      context "can not save" do
        before do
          @item = item
          @credit_card = credit
          @profile = profile
          login_user users.last
        end

        context "with already sold item" do
          before do
            @item.update(status_id: 2)
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.prepare_valid_customer)
            allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
          end

          # クレジットカード情報の更新は失敗か（payjpの顧客作成失敗）
          it 'payjp_token of credit is not updated' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(assigns(:credit_card)).to eq(@credit_card)
          end

          # 取引相手の保存は失敗か
          it 'trading_partner' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(0)
          end

          # オーダーの保存は失敗か
          it 'order' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(0)
          end

          # 商品ステータスの更新は失敗か
          it 'item' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(assigns(:item)).to eq(@item)
          end

          # 意図したビューにリダイレクトしているか
          it "redirects to transaction_buy_path" do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(response).to redirect_to(transaction_buy_path(@item))
          end
        end

        context "without correct response of payjp customer" do
          before do
            allow(Payjp::Customer).to receive(:create).and_return(Payjp::CardError.new('', {}, 402))
            allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
          end

          # クレジットカード情報の更新は失敗か（payjpの顧客作成失敗）
          it 'payjp_token of credit is not updated' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(assigns(:credit_card)).to eq(@credit_card)
          end

          # 取引相手の保存は失敗か
          it 'trading_partner' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(0)
          end

          # オーダーの保存は失敗か
          it 'order' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(0)
          end

          # 商品ステータスの更新は失敗か
          it 'item' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(assigns(:item)).to eq(@item)
          end

          # 意図したビューにリダイレクトしているか
          it "redirects to transaction_buy_path" do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(response).to redirect_to(transaction_buy_path(@item))
          end
        end

        context "without correct response of payjp charge" do
          before do
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.prepare_valid_customer)
            allow(Payjp::Charge).to receive(:create).and_raise(Payjp::CardError.new('', {}, 402))
          end

          # クレジットカード情報の更新は失敗か（payjpの顧客作成失敗）
          it 'payjp_token of credit is not updated' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(assigns(:credit_card)).to eq(@credit_card)
          end

          # 取引相手の保存は失敗か
          it 'trading_partner' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(TradingPartner, :count).by(0)
          end

          # オーダーの保存は失敗か
          it 'order' do
            expect{ post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' } }.to change(Order, :count).by(0)
          end

          # 商品ステータスの更新は失敗か
          it 'item' do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(assigns(:item)).to eq(@item)
          end

          # 意図したビューにリダイレクトしているか
          it "redirects to transaction_buy_path" do
            post :create, params: { id: @item.id, payjp_token: 'tok_76e202b409f3da51a0706605ac81' }
            expect(response).to redirect_to(transaction_buy_path(@item))
          end
        end
      end
    end

    context "not login" do

      # 意図したビューにリダイレクトしているか
      it "redirects to new_user_session_path" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
