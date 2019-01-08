class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :nickname,
    presence: true,
    length: { maximum: 20 }
  validates :email,
    presence: true,
    uniqueness: { message: "メールアドレスに誤りがあります。ご確認いただき、正しく変更してください。" },
    format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*[a-zA-Z]+\z/, allow_blank: true, message: "フォーマットが不適切です" }
  validates :password,
    presence: true,
    confirmation: { message: "パスワードとパスワード（確認）が一致しません" },
    length: { in: 6..128, message: "パスワードは6文字以上128文字以下で入力してください" },
    format: { with: /\A(?=.*[^\d])+/, allow_blank: true, message: "フォーマットが不適切です" }
  validates :password_confirmation,
    presence: true
end
