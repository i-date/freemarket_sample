require 'rails_helper'

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
      it "is valid with password(128 characters)" do
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
        expect(user.errors[:nickname]).to include("入力してください")
      end

      # 登録不可能（email空欄）
      it "is invalid without email" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("入力してください")
      end

      # 登録不可能（password空欄）
      it "is invalid without password" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("入力してください")
      end

      # 登録不可能（password_confirmation空欄）
      it "is invalid without password_confirmation" do
        user = build(:user, password_confirmation: nil)
        user.valid?
        expect(user.errors[:password_confirmation]).to include("入力してください")
      end

      # 登録不可能（email重複）
      it "is invalid with not unique email" do
        email = Faker::Internet.email
        user1 = create(:user, email: email)
        user2 = build(:user, email: email)
        user2.valid?
        expect(user2.errors[:email]).to include("メールアドレスに誤りがあります。ご確認いただき、正しく変更してください。")
      end

      # 登録不可能（passwordが異なる）
      it "is invalid with different password" do
        user = build(:user, password: Faker::Lorem.characters(8), password: Faker::Lorem.characters(9))
        user.valid?
        expect(user.errors[:password_confirmation]).to include("パスワードとパスワード（確認）が一致しません")
      end

      # 登録不可能（文字数境界外、境界値：nickname21文字）
      it "is invalid with nickname(21 characters)" do
        user = build(:user, nickname: Faker::Lorem.characters(21))
        user.valid?
        expect(user.errors[:nickname]).to include("20文字以下で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：password5文字）
      it "is invalid with password(5 characters)" do
        password = Faker::Lorem.characters(5)
        user = build(:user, password: password, password_confirmation: password)
        user.valid?
        expect(user.errors[:password]).to include("パスワードは6文字以上128文字以下で入力してください")
      end

      # 登録不可能（文字数境界外、境界値：password129文字）
      it "is invalid with password(129 characters)" do
        password = Faker::Lorem.characters(129)
        user = build(:user, password: password, password_confirmation: password)
        user.valid?
        expect(user.errors[:password]).to include("パスワードは6文字以上128文字以下で入力してください")
      end

      # 登録不可能（フォーマットエラー：email、@なし）
      it "is invalid with wrong email format(without '@')" do
        user = build(:user, email: "tester1.gmail.com")
        user.valid?
        expect(user.errors[:email]).to include("フォーマットが不適切です")
      end

      # 登録不可能（フォーマットエラー：email、@前文字なし）
      it "is invalid with wrong email format(without characters before @)" do
        user = build(:user, email: "@gmail.com")
        user.valid?
        expect(user.errors[:email]).to include("フォーマットが不適切です")
      end

      # 登録不可能（フォーマットエラー：email、@後文字なし）
      it "is invalid with wrong email format(without characters after @)" do
        user = build(:user, email: "tester1@")
        user.valid?
        expect(user.errors[:email]).to include("フォーマットが不適切です")
      end

      # 登録不可能（フォーマットエラー：email、最後尾文字が数字）
      it "is invalid with wrong email format(last character is number)" do
        user = build(:user, email: "tester1@gmail.com1")
        user.valid?
        expect(user.errors[:email]).to include("フォーマットが不適切です")
      end

      # 登録不可能（フォーマットエラー：password、数字のみ）
      it "is invalid with wrong password format(with only numbers)" do
        password = "12345678"
        user = build(:user, password: password, password_confirmation: password)
        user.valid?
        expect(user.errors[:password]).to include("数字のみのパスワードは設定できません")
      end
    end
  end

  # oauthレスポンスからユーザーを取得するメソッド
  describe '#from_omniauth(auth)' do
    # userに紐付いたsns_credentialに登録済み
    it 'check method with existing sns_credential and user' do
      user = create(:user)
      sns = create(:sns_credential, user_id: user.id)
      auth = { "uid" => "12345678", "provider" => "google_oauth2", "info" => { "email" => user.email } }
      user2 = User.from_omniauth(auth)
      expect(user2).to eq user
    end

    # userは登録済みだが、sns_credentialは登録していない
    it 'check method with existing sns_credential and user' do
      user = create(:user)
      auth = { "uid" => "12345678", "provider" => "google_oauth2", "info" => { "email" => user.email } }
      user2 = User.from_omniauth(auth)
      expect(user2).to eq user
    end

    # userもsns_credentialも登録していない
    it 'check method with existing sns_credential and user' do
      auth = { "uid" => "12345678", "provider" => "google_oauth2", "info" => { "email" => Faker::Internet.email } }
      user = User.from_omniauth(auth)
      expect(user).to eq nil
    end
  end
end
