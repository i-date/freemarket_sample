require 'rails_helper'

RSpec.describe Image, type: :model do
  describe '#create' do

    context "can not save" do

      # 登録不可能（name空欄）
      it "is invalid without name" do
        image = build(:image, name: nil)
        image.valid?
        expect(image.errors[:name]).to include("入力してください")
      end

      # 登録不可能（item_id空欄）
      it "is invalid without item_id" do
        image = build(:image, item_id: nil)
        image.valid?
        expect(image.errors[:item_id]).to include("入力してください")
      end
    end
  end
end
