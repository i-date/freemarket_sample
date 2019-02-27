class Credit < ApplicationRecord
  belongs_to :user

  # :yearに対するバリデーション用正規表現作成
  min_year = Time.new.year.to_s[2,2].to_i
  max_year = min_year + 10
  year_regex = [*(min_year..max_year)].join('|')

  validates :authorization_code,
    presence: true,
    format: { with: /\A\d{14,16}/, allow_blank: true, message: "この番号は登録できません" }
  validates :security_code,
    presence: true,
    format: { with: /\A\d{3,4}/, allow_blank: true, message: "この番号は登録できません" }
  validates :month,
    presence: { message: "選択して下さい" },
    format: { with: /0[1-9]|1[0-2]/, message: "無効な選択です" }
  validates :year,
    presence: { message: "選択して下さい" },
    format: { with: /#{year_regex}/, message: "無効な選択です" }
  validates :user_id,
    presence: true
end
