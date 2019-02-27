class Credit < ApplicationRecord
  belongs_to :user

  # :yearに対するバリデーション用正規表現作成にも使用、そのためvalidation前に以下のメソッドを記述
  def self.get_years
    min_year = Time.new.year.to_s[2,2].to_i
    max_year = min_year + 10
    return years = [*(min_year..max_year)]
  end

  def self.get_months
    ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
  end

  validates :authorization_code,
    presence: true,
    format: { with: /\A\d{14,16}\z/, allow_blank: true, message: "この番号は登録できません" }
  validates :security_code,
    presence: true,
    format: { with: /\A\d{3,4}\z/, allow_blank: true, message: "この番号は登録できません" }
  validates :month,
    presence: { message: "選択して下さい" },
    format: { with: /0[1-9]|1[0-2]/, message: "無効な選択です" }
  validates :year,
    presence: { message: "選択して下さい" },
    format: { with: /#{Credit.get_years.join('|')}/, message: "無効な選択です" }
  validates :user_id,
    presence: true
end
