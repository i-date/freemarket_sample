class Item < ApplicationRecord
  belongs_to :category
  belongs_to :user
  belongs_to :size
  has_many :images
  accepts_nested_attributes_for :images

  enum condition: {
    unused: 1, like_new: 2, invisibly_damaged: 3, slightly_damaged: 4, damaged: 5, bad: 6
  }

  enum shipping_fee: {
    including_postage: 1, cash_on_delivery: 2
  }

  enum shipping_method: {
    undecided: 1, easy_mercari: 2, yu_mail: 3, letter_pack: 4, regular_mail: 5, yamato_transport: 6, yu_pack: 7, click_post: 8, yu_pakcet: 9
  }

  enum shipping_from: {
    hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7,
    ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11, chiba: 12, tokyo: 13, kanagawa: 14,
    niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20,
    gifu: 21, shizuoka: 22, aichi: 23, mie: 24,
    shiga: 25, kyoto: 26, osaka: 27, hyogo: 28, nara: 29, wakayama: 30,
    tottori: 31, shimane: 32, okayama: 33, hiroshima: 34, yamaguchi: 35,
    tokushima: 36, kagawa: 37, ehime: 38, kochi: 39,
    fukuoka: 40, saga: 41, nagasaki: 42, kumamoto: 43, oita: 44, miyazaki: 45, kagoshima: 46, okinawa: 47
  }

  enum days_before_shipping: {
    in_two_days: 1, in_three_days: 2, in_seven_days: 3
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

  scope :sort_update_desc, -> { order("updated_at DESC") }

  def self.get_next_item(item)
    where("id > ?", item.id).order("id ASC").first
  end

  def self.get_previous_item(item)
    where("id < ?", item.id).order("id DESC").first
  end

  def self.get_user_items(item)
    where(user_id: item.user_id).sort_update_desc
  end

  def self.get_category_items(item)
    where(category_id: item.category_id).sort_update_desc
  end
end
