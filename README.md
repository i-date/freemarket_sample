# DB設計

## usersテーブル

|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false|
|password|string|---|
|profile|text|---|
|last_name|string|null: false|
|first_name|string|null: false|
|last_name_kana|string|null: false|
|first_name_kana|string|null: false|
|birth_year|integer|null: false|
|birth_month|integer|null: false|
|birth_day|integer|null: false|
|phone_number|integer|null: false, unique: true|

### Association
- has_many :comments
- has_many :items
- has_many :likes
- has_many :sns_credentials
- has_many :trading_partners
- has_one :addresses
- has_one :credit_cards

## addressesテーブル

|Column|Type|Options|
|------|----|-------|
|zipcode|string|null: false|
|prefecture|integer|null: false|
|city|string|null: false|
|block|string|null: false|
|building|string|---|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :user

## credit_cardsテーブル

|Column|Type|Options|
|------|----|-------|
|authorization_code|integer|null: false, unique: true|
|security_code|integer|null: false|
|month|integer|null: false|
|year|integer|null: false|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :user

## sns_credentialsテーブル

|Column|Type|Options|
|------|----|-------|
|uid|string|null: false, unique: true|
|provider|string|null: false|
|token|text|---|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :user

## likesテーブル

|Column|Type|Options|
|------|----|-------|
|item_id|references|null: false, index: true, foreign_key: true|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :item
- belongs_to :user

## commentsテーブル

|Column|Type|Options|
|------|----|-------|
|body|text|null: false|
|item_id|references|null: false, index: true, foreign_key: true|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :item
- belongs_to :user

## itemsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false, index: true|
|price|integer|null: false|
|description|text|null: false|
|condition|integer|null: false|
|shipping_fee|integer|null: false|
|shipping_from|integer|null: false|
|days_before_shipping|integer|null: false|
|shipping_method|integer|null: false|
|trade_status|integer|null: false|
|brand_id|references|index: true, foreign_key: true|
|category_id|references|null: false, index: true, foreign_key: true|
|user_id|references|null: false, index: true, foreign_key: true|
|size_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :brand
- belongs_to :category
- belongs_to :user
- belongs_to :size
- has_many :comments
- has_many :images
- has_many :likes
- has_one :orders

## brandsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|

### Association
- has_many :item

## imagesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|item_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :item

## categoriesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
|parent_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :parent, class_name: "Category"
- has_many :items
- has_many :child, class_name: "Category", foreign_key: "parent_id"
- has_many :size_charts
- has_many :sizes, through: :size_charts

## sizesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|

### Association
- has_many :categories, through: :size_charts
- has_many :items
- has_many :size_charts

## size_chartsテーブル

|Column|Type|Options|
|------|----|-------|
|category_id|references|null: false, index: true, foreign_key: true|
|size_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :category
- belongs_to :size

## trading_partnersテーブル

|Column|Type|Options|
|------|----|-------|
|buyer_id|references|null: false, index: true, foreign_key: { to_table: :users }|
|seller_id|references|null: false, index: true, foreign_key: { to_table: :users }|

### Association
- belongs_to :buyer_id, class_name: "User"
- belongs_to :seller_id, class_name: "User"
- has_many :order
- has_many :reviews

## reviewsテーブル

|Column|Type|Options|
|------|----|-------|
|body|text|---|
|value|integer|null: false|
|trading_partner_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :trading_partner

## ordersテーブル

|Column|Type|Options|
|------|----|-------|
|status|integer|null: false|
|item_id|references|null: false, index: true, foreign_key: true|
|trading_partner_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :item
- belongs_to :trading_partner
