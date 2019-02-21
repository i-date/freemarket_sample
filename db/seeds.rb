require 'csv'

# # ユーザー
# User.create(nickname: 'test', email: 'test@test.com', password: 'test12345678', password_confirmation: 'test12345678')

# # カテゴリー
# CSV.foreach('db/category.csv') do |record|
#   Category.create(name: record[0], parent_id: record[1], grandparent_id: record[2])
# end

# # ブランド
# CSV.foreach('db/brand.csv') do |record|
#   Brand.create(name: record[0], brand_group_id: record[1])
# end

# # ブランドグループ
# CSV.foreach('db/brand_group.csv') do |record|
#   BrandGroup.create(name: record[0])
# end

# # サイズ
# CSV.foreach('db/size.csv') do |record|
#   Size.create(name: record[0])
# end

# # 商品ステータス
# Status.create([{ name: '出品中'}, { name: '取引中' }, { name: '売却済み' }, { name: '出品停止' }])

# # 商品
# CSV.foreach('db/item.csv') do |record|
#   Item.create(name: record[0], price: record[1], description: record[2], condition: record[3], shipping_fee: record[4], shipping_from: record[5], days_before_shipping: record[6], shipping_method: record[7], status_id: record[8], brand: record[9], category_id: record[10], user_id: record[11], size_id: record[12])
# end
