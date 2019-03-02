require 'rails_helper'

RSpec.describe TradingPartner, type: :model do
  describe '#create' do
    before do
      create_list(:user, 2)
    end

    context "can save" do

      # 登録可能（全項目あり）
      it "is valid with all properties" do
        trading_partner = build(:trading_partner)
        expect(trading_partner).to be_valid
      end
    end

    context "can not save" do

      # 登録不可能（seller_id空欄）
      it "is invalid without seller_id" do
        trading_partner = build(:trading_partner, seller_id: nil)
        trading_partner.valid?
        expect(trading_partner.errors[:seller_id]).to include("入力してください")
      end

      # 登録不可能（buyer_id空欄）
      it "is invalid without buyer_id" do
        trading_partner = build(:trading_partner, buyer: nil)
        trading_partner.valid?
        expect(trading_partner.errors[:buyer]).to include("入力してください")
      end
    end
  end
end
