class Profile < ApplicationRecord
  belongs_to :user

  validates :body,
    length: { maximum: 1000 }
  validates :last_name,
    presence: true,
    length: { maximum: 35 }
  validates :first_name,
    presence: true,
    length: { maximum: 35 }
  validates :last_name_kana,
    presence: true,
    length: { maximum: 35 }
  validates :first_name_kana,
    presence: true,
    length: { maximum: 35 }
  validates :birth_year,
    presence: true
  validates :birth_month,
    presence: true
  validates :birth_day,
    presence: true
  validates :phone_number,
    presence: true,
    length: { maximum: 11, message: "11文字で入力して下さい" },
    uniqueness: { message: "この電話番号は既に登録されています。" },
    format: { with: /\A0[789]0\d{8}/, allow_blank: true, message: "この電話番号は登録できません" }
  validates :zipcode,
    length: { maximum: 7, message: "7文字で入力して下さい" },
    format: { with: /\A\d{7}/, allow_blank: true, message: "この郵便番号は登録できません" }
  validates :prefecture,
    presence: true
  validates :city,
    presence: true
  validates :block,
    presence: true
end
