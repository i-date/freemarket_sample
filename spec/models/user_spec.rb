require 'rails_helper'

# TODO:ログインに必要な最低限以外のテスト追加、日本語化後の修正
describe User do
  describe '#create' do
    context "can save" do

      # 登録可能（全項目あり）
      it "is valid with nickname, email, password and password_confirmation" do
        user = build(:user)
        expect(user).to be_valid
      end

      # 登録可能（全項目あり、境界値：nickname20文字）
      it "is valid with nickname(20 characters), email, password and password_confirmation" do
        user = build(:user, nickname: Faker::Lorem.characters(20))
        expect(user).to be_valid
      end

      # 登録可能（全項目あり、境界値：password6文字）
      it "is valid with password(6 characters)" do
        password = Faker::Lorem.characters(6)
        user = build(:user, password: password, password_confirmation: password)
        expect(user).to be_valid
      end

      # 登録可能（全項目あり、境界値：password128文字）
      it "is invalid with password(128 characters)" do
        password = Faker::Lorem.characters(128)
        user = build(:user, password: password, password_confirmation: password)
        expect(user).to be_valid
      end
    end

    context "can not save" do

      # 登録不可能（nickname空欄）
      it "is invalid without nickname" do
        user = build(:user, nickname: nil)
        user.valid?
        expect(user.errors[:nickname]).to include("can't be blank")
      end

      # 登録不可能（email空欄）
      it "is invalid without email" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end

      # 登録不可能（password空欄）
      it "is invalid without password" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end

      # 登録不可能（password_confirmation空欄）
      it "is invalid without password_confirmation" do
        user = build(:user, password_confirmation: nil)
        user.valid?
        expect(user.errors[:password_confirmation]).to include("can't be blank")
      end

      # 登録不可能（email重複）
      it "is invalid with not unique email" do
        email = Faker::Internet.email
        user1 = create(:user, email: email)
        user2 = build(:user, email: email)
        user2.valid?
        expect(user2.errors[:email]).to include("has already been taken")
      end

      # 登録不可能（passwordが異なる）
      it "is invalid with different password" do
        user = build(:user, password: Faker::Lorem.characters(8), password: Faker::Lorem.characters(9))
        user.valid?
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end

      # 登録不可能（文字数境界外、境界値：nickname21文字）
      it "is invalid with nickname(21 characters)" do
        user = build(:user, nickname: Faker::Lorem.characters(21))
        user.valid?
        expect(user.errors[:nickname]).to include("is too long (maximum is 20 characters)")
      end

      # 登録不可能（文字数境界外、境界値：password5文字）
      it "is invalid with password(5 characters)" do
        password = Faker::Lorem.characters(5)
        user = build(:user, password: password, password_confirmation: password)
        user.valid?
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      # 登録不可能（文字数境界外、境界値：password129文字）
      it "is invalid with password(129 characters)" do
        password = Faker::Lorem.characters(129)
        user = build(:user, password: password, password_confirmation: password)
        user.valid?
        expect(user.errors[:password]).to include("is too long (maximum is 128 characters)")
      end

      # 登録不可能（フォーマットエラー：email、@なし）
      it "is invalid with wrong email format(without '@')" do
        user = build(:user, email: "tester1.gmail.com")
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end

      # 登録不可能（フォーマットエラー：email、@前文字なし）
      it "is invalid with wrong email format(without characters before @)" do
        user = build(:user, email: "@gmail.com")
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end

      # 登録不可能（フォーマットエラー：email、@後文字なし）
      it "is invalid with wrong email format(without characters after @)" do
        user = build(:user, email: "tester1@")
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end

      # 登録不可能（フォーマットエラー：email、最後尾文字が数字）
      it "is invalid with wrong email format(last character is number)" do
        user = build(:user, email: "tester1@gmail.com1")
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end

      # 登録不可能（フォーマットエラー：password、数字のみ）
      it "is invalid with wrong password format(with only numbers)" do
        password = "12345678"
        user = build(:user, password: password, password_confirmation: password)
        user.valid?
        expect(user.errors[:password]).to include("is invalid")
      end
    end
  end
end
