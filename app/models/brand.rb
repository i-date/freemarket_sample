class Brand < ApplicationRecord
  belongs_to :brand_group

  private

  def self.headerList
    ['シャネル', 'ナイキ', 'ルイ ヴィトン', 'シュプリーム', 'アディダス', 'ブランド一覧']
  end
end
