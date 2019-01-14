require 'rails_helper'

describe SnsUser, type: :model do
  # User登録情報取得メソッド
  describe '#user_params' do
    it 'check method' do
      sns_user = build(:sns_user)
      user_param = { nickname: sns_user.nickname, email: sns_user.email, password: sns_user.password, password_confirmation: sns_user.password_confirmation }
      expect(sns_user.user_params).to eq user_param
    end
  end

  # SnsCredential登録情報取得メソッド
  describe '#sns_params' do
    it 'check method' do
      sns_user = build(:sns_user)
      sns_param = { uid: sns_user.uid, provider: sns_user.provider }
      expect(sns_user.sns_params).to eq sns_param
    end
  end

  # フォームに渡す変数作成メソッド
  describe '#temporary_params(auth)' do
    it 'check method' do
      auth = { "uid" => "12345678", "provider" => "facebook", "info" => { "email" => Faker::Internet.email } }
      response = SnsUser.temporary_params(auth)
      expect(response.email).to    eq auth["info"]["email"]
      expect(response.uid).to      eq auth["uid"]
      expect(response.provider).to eq auth["provider"]
    end
  end
end
