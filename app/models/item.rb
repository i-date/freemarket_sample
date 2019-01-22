class Item < ApplicationRecord
  belongs_to :category
  belongs_to :user
  belongs_to :size
  has_many :images

  enum condition: {
    新品・未使用: 1, 未使用に近い: 2, 目立った傷や汚れなし: 3, やや傷や汚れあり: 4, 傷や汚れあり: 5, 全面的に状態が悪い: 6
  }

  enum shipping_fee: {
    送料込み・出品者負担: 1, 着払い・購入者負担: 2
  }

  enum shipping_method: {
    未定: 1, らくらくメルカリ便: 2, ゆうメール: 3, レターパック: 4, 普通郵便: 5, クロネコヤマト: 6, ゆうパック: 7, クリックポスト: 8, ゆうパケット: 9
  }

  enum shipping_from: {
    北海道: 1, 青森県: 2, 岩手県: 3, 宮城県: 4, 秋田県: 5, 山形県: 6, 福島県: 7,
    茨城県: 8, 栃木県: 9, 群馬県: 10, 埼玉県: 11, 千葉県: 12, 東京都: 13, 神奈川県: 14,
    新潟県: 15, 富山県: 16, 石川県: 17, 福井県: 18, 山梨県: 19, 長野県: 20,
    岐阜県: 21, 静岡県: 22, 愛知県: 23, 三重県: 24,
    滋賀県: 25, 京都府: 26, 大阪府: 27, 兵庫県: 28, 奈良県: 29, 和歌山県: 30,
    鳥取県: 31, 島根県: 32, 岡山県: 33, 広島県: 34, 山口県: 35,
    徳島県: 36, 香川県: 37, 愛媛県: 38, 高知県: 39,
    福岡県: 40, 佐賀県: 41, 長崎県: 42, 熊本県: 43, 大分県: 44, 宮崎県: 45, 鹿児島県: 46, 沖縄県: 47
  }

  enum days_before_shipping: {
    '1〜2日で発送' => 1, '2〜3日で発送' => 2, '4〜7日で発送' => 3
  }

  validates :name,
    presence: true,
    length: { maximum: 40 }
  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999, message: "販売価格は300以上9,999,999以内で入力してください" }
  validates :description,
    presence: true,
    length: { maximum: 1000 }
  validates :condition,
    presence: true
  validates :shipping_fee,
    presence: true
  validates :shipping_from,
    presence: true
  validates :days_before_shipping,
    presence: true
  validates :shipping_method,
    presence: true
  validates :status,
    presence: true
  validates :brand,
    length: { maximum: 40 }
  validates :category_id,
    presence: true
  validates :user_id,
    presence: true
  validates :size_id,
    presence: true
end
