require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#create' do
    before do
      create_list(:user, 2)
      create(:trading_partner)
      create(:category)
      create(:status)
      create(:size)
      create(:item)
    end

    context "can save" do

      # 登録可能（全項目あり）
      it "is valid with all properties" do
        order = build(:order)
        expect(order).to be_valid
      end
    end

    context "can not save" do

      # 登録不可能（item_id空欄）
      it "is invalid without item_id" do
        order = build(:order, item_id: nil)
        order.valid?
        expect(order.errors[:item_id]).to include("入力してください")
      end

      # 登録不可能（trading_partner_id空欄）
      it "is invalid without trading_partner_id" do
        order = build(:order, trading_partner_id: nil)
        order.valid?
        expect(order.errors[:trading_partner]).to include("入力してください")
      end
    end
  end
end
