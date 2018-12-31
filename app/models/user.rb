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
    uniqueness: true,
    format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*[a-zA-Z]+\z/ }
  validates :password,
    presence: true,
    confirmation: true,
    length: { in: 6..128 },
    format: { with: /\A(?=.*[^\d])+/ }
  validates :password_confirmation,
    presence: true
end
