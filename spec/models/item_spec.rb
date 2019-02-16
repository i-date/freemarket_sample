require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#create' do

    before do
      user = create(:user)
      category = create(:category)
      size = create(:size)
      status = create(:status)
    end

    context "can save" do

      # 登録可能（全項目あり）
      it "is valid with all propeties" do
        item = build(:item)
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：name40文字）
      it "is valid with all propeties and name(40 characters)" do
        item = build(:item, name: Faker::Lorem.characters(40))
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：description1000文字）
      it "is valid with all propeties and description(1000 characters)" do
        item = build(:item, description: Faker::Lorem.characters(1000))
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：brand40文字）
      it "is valid with all propeties and brand(40 characters)" do
        item = build(:item, brand: Faker::Lorem.characters(40))
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：price300）
      it "is valid with all propeties and price(300)" do
        item = build(:item, price: 300)
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：price9999999）
      it "is valid with all propeties and price(9999999)" do
        item = build(:item, price: 9999999)
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：category_id1）
      it "is valid with all propeties and category_id(1)" do
        item = build(:item, category_id: 1)
        expect(item).to be_valid
      end

      # 登録可能（全項目あり、境界値：size_id1）
      it "is valid with all propeties and size_id(1)" do
        item = build(:item, size_id: 1)
        expect(item).to be_valid
      end
    end

    context "can not save" do

      # 登録不可能（name空欄）
      it "is invalid without name" do
        item = build(:item, name: nil)
        item.valid?
        expect(item.errors[:name]).to include("入力してください")
      end

      # 登録不可能（price空欄）
      it "is invalid without price" do
        item = build(:item, price: nil)
        item.valid?
        expect(item.errors[:price]).to include("販売価格は300以上9,999,999以内で入力してください")
      end

      # 登録不可能（description空欄）
      it "is invalid without description" do
        item = build(:item, description: nil)
        item.valid?
        expect(item.errors[:description]).to include("入力してください")
      end

      # 登録不可能（condition空欄）
      it "is invalid without condition" do
        item = build(:item, condition: nil)
        item.valid?
        expect(item.errors[:condition]).to include("選択して下さい")
      end

      # 登録不可能（shipping_fee空欄）
      it "is invalid without shipping_fee" do
        item = build(:item, shipping_fee: nil)
        item.valid?
        expect(item.errors[:shipping_fee]).to include("選択して下さい")
      end

      # 登録不可能（shipping_from空欄）
      it "is invalid without shipping_from" do
        item = build(:item, shipping_from: nil)
        item.valid?
        expect(item.errors[:shipping_from]).to include("選択して下さい")
      end

      # 登録不可能（days_before_shipping空欄）
      it "is invalid without days_before_shipping" do
        item = build(:item, days_before_shipping: nil)
        item.valid?
        expect(item.errors[:days_before_shipping]).to include("選択して下さい")
      end

      # 登録不可能（shipping_method空欄）
      it "is invalid without shipping_method" do
        item = build(:item, shipping_method: nil)
        item.valid?
        expect(item.errors[:shipping_method]).to include("選択して下さい")
      end

      # 登録不可能（status_id空欄）
      it "is invalid without status_id" do
        item = build(:item, status_id: nil)
        item.valid?
        expect(item.errors[:status_id]).to include("入力してください")
      end

      # 登録不可能（category_id空欄）
      it "is invalid without category_id" do
        item = build(:item, category_id: nil)
        item.valid?
        expect(item.errors[:category_id]).to include("選択して下さい")
      end

      # 登録不可能（user_id空欄）
      it "is invalid without user_id" do
        item = build(:item, user_id: nil)
        item.valid?
        expect(item.errors[:user_id]).to include("入力してください")
      end

      # 登録不可能（size_id空欄）
      it "is invalid without size_id" do
        item = build(:item, size_id: nil)
        item.valid?
        expect(item.errors[:size_id]).to include("選択して下さい")
      end

      # 登録不可能（文字数境界外、境界値：name41文字）
      it "is invalid with name(41 characters)" do
        item = build(:item, name: Faker::Lorem.characters(41))
        item.valid?
        expect(item.errors[:name]).to include("40文字以下で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：description1001文字）
      it "is invalid with description(1001 characters)" do
        item = build(:item, description: Faker::Lorem.characters(10001))
        item.valid?
        expect(item.errors[:description]).to include("1000文字以下で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：brand41文字）
      it "is invalid with brand(41 characters)" do
        item = build(:item, brand: Faker::Lorem.characters(41))
        item.valid?
        expect(item.errors[:brand]).to include("40文字以下で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：price299）
      it "is invalid with price(299)" do
        item = build(:item, price: 299)
        item.valid?
        expect(item.errors[:price]).to include("販売価格は300以上9,999,999以内で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：price10000000）
      it "is invalid with price(10000000)" do
        item = build(:item, price: 10000000)
        item.valid?
        expect(item.errors[:price]).to include("販売価格は300以上9,999,999以内で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：category_id0）
      it "is invalid with category_id(0)" do
        item = build(:item, category_id: 0)
        item.valid?
        expect(item.errors[:category_id]).to include("選択して下さい")
      end

      # 登録不可能（文字数境界外、境界値：size_id0）
      it "is invalid with size_id(0)" do
        item = build(:item, size_id: 0)
        item.valid?
        expect(item.errors[:size_id]).to include("選択して下さい")
      end
    end
  end
end
