class Profile < ApplicationRecord
  belongs_to :user

  enum prefecture: {
    hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7,
    ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11, chiba: 12, tokyo: 13, kanagawa: 14,
    niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20,
    gifu: 21, shizuoka: 22, aichi: 23, mie: 24,
    shiga: 25, kyoto: 26, osaka: 27, hyogo: 28, nara: 29, wakayama: 30,
    tottori: 31, shimane: 32, okayama: 33, hiroshima: 34, yamaguchi: 35,
    tokushima: 36, kagawa: 37, ehime: 38, kochi: 39,
    fukuoka: 40, saga: 41, nagasaki: 42, kumamoto: 43, oita: 44, miyazaki: 45, kagoshima: 46, okinawa: 47
  }

  validates :nickname,
    presence: true,
    length: { maximum: 20 },
    on: :profile_body
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

  def set_hyphen
    zipcode.to_s.insert(3, '-')
  end

  def set_address
    prefecture_i18n + "\s" + city + "\s" + block + "\s" + building
  end

  def set_fullname
    last_name + "\s" + first_name
  end
end
