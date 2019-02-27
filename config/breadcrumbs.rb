# ルート
crumb :root do
  link 'メルカリ', root_path
end

# -------------------- マイページ関係 --------------------
# トップ
crumb :mypage do
  link 'マイページ', mypage_top_path
  parent :root
end

# ログアウト
crumb :mypage_logout do
  link 'ログアウト', mypage_logout_path
  parent :mypage
end

# プロフィール
crumb :mypage_profile do
  link 'プロフィール', mypage_profile_path
  parent :mypage
end

# 本人情報の登録
crumb :mypage_identification do
  link '本人情報の登録', mypage_identification_path
  parent :mypage
end

# 支払方法の確認
crumb :mypage_credit do
  link '支払い方法', mypage_card_index_path
  parent :mypage
end

# クレジットカード情報の登録
crumb :mypage_new_credit do
  link 'クレジットカード情報入力', new_mypage_card_path
  parent :mypage_credit
end

# -------------------- 商品関係 --------------------
# 商品詳細
crumb :item do |item|
  link "#{item.name}", item_path(item)
  parent :root
end

# 商品検索結果
crumb :search do |query|
  link "#{query}"
  parent :root
end
