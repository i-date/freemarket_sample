class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname,
    presence: true,
    length: { maximum: 20 }
  validates :email,
    presence: true,
    format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*[a-zA-Z]+\z/ }
  validates :password,
    presence: true,
    format: { with: /\A(?=.*[^\d])+/ },
    length: { in: 6..128 }
end
